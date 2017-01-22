#!/usr/bin/env perl

# ARNG-6475
# - Agent moves single message to a different queue = QUEUE_RELOCATE_{ACTION, UI_READY} 
# - Agent assigns single message to a different user = ASSIGN_USER_{ACTION, UI_READY} 
# - zeit von Doppelklick bis man was bearbeiten kann. (mit und ohne Kanalauswahl) = PROCESSING 
# - Agent sends a message. Time until agent can do the next action. = SEND_DOCUMENT_{ACTION, UI_READY} 
# - Agents selects a message in a queue = QUEUE_SELECTED_UI_READY 
# - Agents selects a message = DOCUMENT_SELCTED_UI_READY 


use strict;
use warnings;

use Data::Dumper;
use Storable qw ( dclone );

my $PERF_DATA_ID	= '>>PERF_DATA';
my $DOC_ID			= 'DOC_ID:';
my $USER_ID			= 'USER_ID:';
my $QUEUE_ID		= 'QUEUE_ID:';

my $RESULT = {};

#
# Decomposes a Log-Line into relevant components
# param  line (string)
# return hash
#
sub decompose {
	# decomposes message into its components
	my $line = shift;
	my $result;
	if ($line =~ m/$PERF_DATA_ID\|(.*)/) {
		# TODO get rid of \| (escaped pipe)
		my @data = split /\|/, $1;
		$data[2] =~ s/\s+$//g;
		$result = { 
			t			=> $data[0], 
			uid			=> $data[1],
			action_id 	=> [ split('\/', $data[2]) ], 
			info		=> $data[3],
			msg 		=> $data[4], 
		};
	}
	return $result;
}

#
# Records a Result in the global variable $RESULT
# global $RESULT
# param  id (String)
# param  duration (int)
#
sub _setResult {
	my $uid = shift;
	my $id = shift;
	my $duration = shift;
	
	unless ( exists $RESULT->{$uid} && exists $RESULT->{$uid}->{$id} ) {
		$RESULT->{$uid}->{$id} = { 
			count	=> 1, 
			sum		=> $duration, 
			min		=> $duration, 
			max		=> $duration,
			last	=> $duration,
			med     => [ $duration ],
		}
	} else {
		my $result = $RESULT->{$uid}->{$id};
	
		$result->{count}	+= 1;
		$result->{sum}		+= $duration;
		$result->{min} 		= $duration if $duration < $result->{min};
		$result->{max} 		= $duration if $duration > $result->{max};
		$result->{last}		= $duration;
		push @{$result->{med}}, $duration;
	}
}

#
# Records a Result in the global variable $RESULT
# global $RESULT
# param  id (String)
# param  duration (int)
#
sub setResult {
	my $uid = shift;
	_setResult($uid, @_);
	_setResult("__ALL__", @_);
}

#
# Print the recorded Values from global variable $RESULT
# global $RESULT
#
sub report {
	foreach my $uid (sort keys %$RESULT) {
		print "ID '$uid':\n";
		foreach my $key (sort keys %{$RESULT->{$uid}}) {
			my $result = $RESULT->{$uid}->{$key};
			my $med = (sort @{$result->{med}})[ scalar @{$result->{med}} / 2 ] / 1000;
			print  sprintf "  %-40s avg=%7.3fs med=%7.3fs   min=%7.3fs max=%7.3fs last=%7.3f cnt=%4d\n", ($key.':'), ($result->{sum} / $result->{count} / 1000), $med, $result->{min} / 1000, $result->{max} / 1000, $result->{last} / 1000, $result->{count};
		}
	}
}

#
# Print the recorded Values from global variable $RESULT as CSV
# global $RESULT
# Format:
#	UID, ID, AVG, MIN, MAX, LAST, CNT
#
sub format_csv {
	my $s = shift;
	$s =~ s/[.]/,/;   
	return $s;
}

sub report_csv {
	print "uid;id;avg;med;min;max;last;cnt\n";
	foreach my $uid (sort keys %$RESULT) {
		foreach my $key (sort keys %{$RESULT->{$uid}}) {
			my $result = $RESULT->{$uid}->{$key};
			my $med = (sort @{$result->{med}})[ scalar @{$result->{med}} / 2 ] / 1000;
			print  sprintf "%s;%s;%s;%s;%s;%s;%s;%s\n", 
				format_csv($uid ne '__ALL__' ? "u$uid" : $uid), 
				format_csv($key), 
				format_csv($result->{sum} / $result->{count} / 1000),
				format_csv($med), 
				format_csv($result->{min} / 1000), 
				format_csv($result->{max} / 1000), 
				format_csv($result->{last} / 1000), 
				format_csv($result->{count});
		}
	}
}


#
# Records a Action
# * Action start if action_id is equal "begin_id"
# * Action is finished if action_id is equal "end_id"
# * Action is failed if action_id is equal "end_failed_id" in this case time is not recorded
#
# param $result_id		identifier (String) for recording
# param $begin_id		identifier (String) (contained in log message)
# param $end_id			identifier (String) (contained in log message)
# param $end_failedid	identifier (String) (contained in log message)
#
sub testSimple {
	my ($msg, $result_id, $begin_id, $end_id, $end_failed_id) = @_;	
	return unless $msg;
	
	$end_id ||= [];
	$end_id = [ $end_id ] unless ref $end_id eq 'ARRAY';

	my $tstate_id = "${result_id}_$msg->{uid}";

	our $tstate ||= {};
	if ($msg->{action_id}->[1] eq ($begin_id || '') ) {
		$tstate->{$tstate_id} = $msg->{t};
	} elsif ( grep { $_ eq $msg->{action_id}->[1] } @$end_id ) {
		if ($tstate->{$tstate_id}) {
			setResult($msg->{uid}, $result_id, $msg->{t} - $tstate->{$tstate_id});
		}
		$tstate->{$tstate_id} = 0;
	} elsif ($msg->{action_id}->[1] eq ($end_failed_id  || '') ) {
		# action failed discard measurement
		$tstate->{$tstate_id} = 0;
	}
}



sub testUserController {
	my $msg = shift;
	return unless $msg;

	if ( $msg->{action_id}->[0] eq 'UserController' ) {
		my $cl = dclone($msg);
		$cl->{action_id} = [ @{$msg->{action_id}}[1..scalar @{$msg->{action_id}}-1] ];
		testSimple($cl, "UC.".$cl->{action_id}->[0], "start", "end");
	}
	
	if ( $msg->{action_id}->[0] eq 'QueueHelper' ) {
		my $cl = dclone($msg);
		$cl->{action_id} = [ @{$msg->{action_id}}[1..scalar @{$msg->{action_id}}-1] ];
		testSimple($cl, "QH.".$cl->{action_id}->[0], "start", "end");
	}
	
	if ( $msg->{action_id}->[0] eq 'AssignedGroupsPanel' ) {
		my $cl = dclone($msg);
		$cl->{action_id} = [ @{$msg->{action_id}}[1..scalar @{$msg->{action_id}}-1] ];
		testSimple($cl, "AG.".$cl->{action_id}->[0], "start", "end");
	}
	
	if ( $msg->{action_id}->[0] eq 'UserView' ) {
		my $cl = dclone($msg);
		$cl->{action_id} = [ @{$msg->{action_id}}[1..scalar @{$msg->{action_id}}-1] ];
		testSimple($cl, "UV.".$cl->{action_id}->[0], "start", "end");
	}
}


sub testDocumentGridDataChanged {
	my $msg = shift;
	return unless $msg;
	
	if ( $msg->{action_id}->[0] eq 'DOCUMENT_GRID' ) {
		testSimple($msg, 'DOCUMENT_GRID_DATA_CHANGED', 'DATA_CHANGED_BEGIN', 'DATA_CHANGED_END');
	}
}

sub testQueuePanelLoad {
	my $msg = shift;
	return unless $msg;
	
	if ( $msg->{action_id}->[0] eq 'QUEUE_PANEL' ) {
		testSimple($msg, 'QUEUE_PANEL_LOAD', 'LOAD_BEGIN', ['LOAD_EMPTY', 'LOAD_FINISHED']);
	}
}

sub testSolutionsPanel {
	my $msg = shift;
	return unless $msg;
	
	if ( $msg->{action_id}->[0] eq 'SOLUTIONS_PANEL' ) {
		testSimple($msg, 'SOLUTIONS_PANEL_SHOW_TEMPLATES', 'SHOW_TEMPLATES_BEGIN', 'SHOW_TEMPLATES_FINISHED');
		testSimple($msg, 'SOLUTIONS_PANEL_ADD_TREE', 'ADD_TREE_START', 'ADD_TREE_FINISHED');
		testSimple($msg, 'SOLUTIONS_PANEL_APPLY_FILTERS', 'APPLY_FILTERS_START', 'APPLY_FILTERS_FINISHED');
		
		if ( $msg->{action_id}->[1] eq 'LOAD_SOLUTIONS' ) {
			my $cl = dclone($msg);
			$cl->{action_id} = [ $msg->{action_id}->[0], @{$msg->{action_id}}[2..scalar @{$msg->{action_id}}-1] ];
			testSimple($cl, 'SOLUTIONS_PANEL_LOAD_SOLUTIONS', 'ON_SUCCESS_BEGIN', 'ON_SUCCESS_END');
		}
	}
}

sub testTicketTreePanel {
	my $msg = shift;
	return unless $msg;
	
	if ( $msg->{action_id}->[0] eq 'TICKET_TREE_PANEL' ) {
		testSimple($msg, 'TICKET_TREE_PANEL_FILL_TREE_MODEL', 'FILL_TREE_MODEL_BEGIN', 'FILL_TREE_MODEL_END');
		testSimple($msg, 'TICKET_TREE_PANEL_APPLY_LOADER_RESULT', 'APPLY_LOADER_RESULT_BEGIN', 'APPLY_LOADER_RESULT_END');
	}
}

#
# Tests if the whole action_id matches
# Example: 		check_action_matches( [ 'TICKET_TREE_PANEL_FILL_TREE_MODEL', 'FILL_TREE_MODEL_BEGIN' ], $msg);
#
# param  $w 	Array of String
# param  $msg	decomposed message
# return 1 		if matches
# return 0 		otherwise
#
sub check_action_matches {
	my $w = shift;
	my $msg = shift;
	
	my $match = 1;
	
	for my $i ( 0..scalar @$w - 1) {
		if ( $w->[$i] ne ( $msg->{action_id}->[$i] || '' ) ) {
			$match = 0;
		}
	}
	
	return $match;
}
#
# Checks if a list of actions has been occurd
# param  $msg	excpected actions
# return ArrayOfActions or Emptylist			reduced list of actions if actions has been matched
# return (ArrayOfActions or Emptylist, changed) if wantarray additionaly a flag will be returned - the flag is true if something has changed
#
sub wait_for {
	my $state = shift  || [];
	my $msg = shift;
	
	my $new_state = [];
	for my $w ( @$state ) {
		push @$new_state, $w 
			unless check_action_matches($w, $msg);
	}
	
	return ($new_state, scalar @$state != scalar @$new_state) if wantarray;
	return $new_state;
}

#
# records the time from Processing start until UI is ready
# if a channel dialog occurs this time will be substracted
#
sub testProcessing {
	my $msg = shift;
	return unless $msg;
	
	my $doc_id = $1 if $msg->{action_id}->[0] =~ /$DOC_ID(.*)/;
	our $pstate ||= { doc_id => undef, chan_dialog_time => 0, processing_start => undef, wait_for => undef };
		
	if ( $msg->{action_id}->[1] eq 'PROCESSING_START_BEFORE_CHAN' ) {
		# start processing with channel dialog
		$pstate = { doc_id => $doc_id, chan_dialog_time => 0, processing_start => $msg->{t}, wait_for => undef };
	} elsif ( $msg->{action_id}->[1] eq 'CHAN_DIALOG_READY' ) {
		$pstate->{chan_dialog_time} = $msg->{t};
	} elsif ( $msg->{action_id}->[1] eq 'CHAN_DIALOG_SELECT' ) {
		$pstate->{chan_dialog_time} = $msg->{t} - $pstate->{chan_dialog_time}
			if $pstate->{chan_dialog_time};
	} elsif ( $msg->{action_id}->[1] eq 'CHAN_DIALOG_NO_SELECT' ) {
		$pstate = { doc_id => undef, chan_dialog_time => 0, processing_start => undef, wait_for => undef };
	} elsif ( $msg->{action_id}->[1] eq 'PROCESSING_START' ) {
		if ( !$pstate->{doc_id} || ($pstate->{doc_id} ne $doc_id) ) {
			$pstate = { doc_id => $doc_id, chan_dialog_time => 0,  processing_start => $msg->{t}, wait_for => undef };
		}
		$pstate->{wait_for} = [ 
			["DOC_ID:$doc_id", 'PROCESSING_CK_EDITOR_READY'],
			['SOLUTIONS_PANEL', 'LOAD_SOLUTIONS', 'ON_SUCCESS_FINISHED'],
			['SOLUTIONS_PANEL', 'SHOW_TEMPLATES_FINISHED'],
		];
		
		push @{$pstate->{wait_for}}, ['QUEUE_PANEL', 'LOAD_FINISHED'] 
			unless ($msg->{info} eq 'PERFMODE')
	} elsif ( $pstate->{wait_for} ) {
		$pstate->{wait_for} = wait_for($pstate->{wait_for}, $msg);

		unless ( scalar @{$pstate->{wait_for}} ) {
			# finished

			setResult($msg->{uid}, 'PROCESSING', $msg->{t} - $pstate->{processing_start} - $pstate->{chan_dialog_time});
			
			$pstate = { doc_id => undef, chan_dialog_time => 0, processing_start => undef, wait_for => undef };
		}
	}
}

sub testUserAssign {
	my $msg = shift;
	return unless $msg;
	
	if ( $msg->{action_id}->[0] =~ /$USER_ID(.*)/ ) {
		my $user_id = $1;
	
		testSimple($msg, 'ASSIGN_USER_ACTION', 'ASSIGN_USER_START', 'ASSIGN_USER_OK', 'ASSIGN_USER_FAILED');
	}
}

sub testUserAssignUiReady {
	my $msg = shift;
	return unless $msg;
	
	our $uaurstate ||= {};
	
	my $user_id = $1 if $msg->{action_id}->[0] =~ /$USER_ID(.*)/;
	if ( $msg->{action_id}->[1] eq 'ASSIGN_USER_START' ) {
		$uaurstate->{t} = $msg->{t};
	} elsif ( $msg->{action_id}->[1] eq 'ASSIGN_USER_OK' ) {
		$uaurstate->{wait_for} = [
			['DOCUMENT_GRID', 'DATA_CHANGED_END'],
			['QUEUE_PANEL', 'LOAD_FINISHED'],
			['TICKET_TREE_PANEL', 'FILL_TREE_MODEL_END'],
			['TICKET_TREE_PANEL', 'APPLY_LOADER_RESULT_END'],
		];
	} elsif ( $msg->{action_id}->[1] eq 'ASSIGN_USER_FAILED' ) {
		$uaurstate = {};
	} elsif ( $uaurstate->{wait_for} ) {
		$uaurstate->{wait_for} =  wait_for($uaurstate->{wait_for}, $msg);
		
		unless ( scalar @{$uaurstate->{wait_for}} ) {
			# finished

			setResult($msg->{uid}, 'ASSIGN_USER_UI_READY', $msg->{t} - $uaurstate->{t});
			
			$uaurstate = {};
		}
	}
}

sub testQueueRelocate {
	my $msg = shift;
	return unless $msg;
	
	if ( $msg->{action_id}->[0] =~ /$QUEUE_ID(.*)/ ) {
		my $queue_id = $1;
		
		testSimple($msg, 'QUEUE_RELOCATE', 'RELOCATE_QUEUE_START', 'RELOCATE_QUEUE_OK', 'RELOCATE_QUEUE_FAILED');
	}
}

sub testQueueRelocateUiReady {
	my $msg = shift;
	return unless $msg;
	
	our $qrurstate ||= {};
	
	my $queue_id = $1 if $msg->{action_id}->[0] =~ /$QUEUE_ID(.*)/;
	if ( $msg->{action_id}->[1] eq 'RELOCATE_QUEUE_START' ) {
		$qrurstate->{t} = $msg->{t};
	} elsif ( $msg->{action_id}->[1] eq 'RELOCATE_QUEUE_OK' ) {
		$qrurstate->{wait_for} = [
			['DOCUMENT_GRID', 'DATA_CHANGED_END'],
			['QUEUE_PANEL', 'LOAD_FINISHED'],
			['TICKET_TREE_PANEL', 'APPLY_LOADER_RESULT_END'],
		];
	} elsif ( $msg->{action_id}->[1] eq 'RELOCATE_QUEUE_FAILED' ) {
		$qrurstate = {};
	} elsif ( $qrurstate->{wait_for} ) {
		$qrurstate->{wait_for} =  wait_for($qrurstate->{wait_for}, $msg);
		
		unless ( scalar @{$qrurstate->{wait_for}} ) {
			# finished

			setResult($msg->{uid}, 'QUEUE_RELOCATE_UI_READY', $msg->{t} - $qrurstate->{t});
			
			$qrurstate = {};
		}
	}
}

sub testDocumentSend {
	my $msg = shift;
	return unless $msg;
	
	if ( $msg->{action_id}->[0] =~ /$DOC_ID(.*)/ ) {
		my $doc_id = $1;
		
		testSimple($msg, 'DOCUMENT_SEND', 'SEND_START', 'SEND_OK', 'SEND_FAILED');
	}
}

sub testDocumentSendUiReady {
	my $msg = shift;
	return unless $msg;

	our $dsurstate ||= {};
	
	my $doc_id = $1 if $msg->{action_id}->[0] =~ /$DOC_ID(.*)/;
	if ( $msg->{action_id}->[1] eq 'SEND_START' ) {
		$dsurstate->{t} = $msg->{t};
	} elsif ( $msg->{action_id}->[1] eq 'SEND_OK' ) {
		$dsurstate->{wait_for} = [
			['DOCUMENT_GRID', 'DATA_CHANGED_END'],
			['QUEUE_PANEL', 'LOAD_FINISHED'],
			
		];
		push @{$dsurstate->{wait_for}}, ['TICKET_TREE_PANEL', 'APPLY_LOADER_RESULT_END'] 
			unless ($msg->{info} eq 'PERFMODE');
	} elsif ( $msg->{action_id}->[1] eq 'SEND_FAILED' ) {
		$dsurstate = {};
	} elsif ( $dsurstate->{wait_for} ) {
		$dsurstate->{wait_for} =  wait_for($dsurstate->{wait_for}, $msg);
		
		unless ( scalar @{$dsurstate->{wait_for}} ) {
			# finished

			setResult($msg->{uid}, 'DOCUMENT_SENT_UI_READY', $msg->{t} - $dsurstate->{t});
			
			$dsurstate = {};
		}
	}
}

sub testDocumentSelectedUiReady {
	my $msg = shift;
	return unless $msg;

	our $dsendurstate ||= {};
	
	my $doc_id = $1 if $msg->{action_id}->[0] =~ /$DOC_ID(.*)/;
	if ( $msg->{action_id}->[1] eq 'DOCUMENT_SELECTED' ) {
		$dsendurstate->{t} = $msg->{t};
		$dsendurstate->{wait_for} = [
			['TICKET_TREE_PANEL', 'FILL_TREE_MODEL_END'],
			['TICKET_TREE_PANEL', 'APPLY_LOADER_RESULT_END'],
		];
	} elsif ( $dsendurstate->{wait_for} ) {
		$dsendurstate->{wait_for} =  wait_for($dsendurstate->{wait_for}, $msg);
		
		unless ( scalar @{$dsendurstate->{wait_for}} ) {
			# finished

			setResult($msg->{uid}, 'DOCUMENT_SELECTED_UI_READY', $msg->{t} - $dsendurstate->{t});
			
			$dsendurstate = {};
		}
	}
}

sub testQueueSelectedUiReady {
	my $msg = shift;
	return unless $msg;

	our $qsurstate ||= {};
	
	my $queue_id = $1 if $msg->{action_id}->[0] =~ /$QUEUE_ID(.*)/;
	if ( $msg->{action_id}->[1] eq 'QUEUE_SELECTED' ) {
		$qsurstate->{t} = $msg->{t};
		$qsurstate->{wait_for} = [
			['QUEUE_PANEL', 'LOAD_FINISHED'],
			['DOCUMENT_GRID', 'DATA_CHANGED_END'],
			['TICKET_TREE_PANEL', 'APPLY_LOADER_RESULT_END'],
		];
	} elsif ( $qsurstate->{wait_for} ) {
		$qsurstate->{wait_for} =  wait_for($qsurstate->{wait_for}, $msg);
		
		unless ( scalar @{$qsurstate->{wait_for}} ) {
			# finished

			setResult($msg->{uid}, 'QUEUE_SELECTED_UI_READY', $msg->{t} - $qsurstate->{t});
			
			$qsurstate = {};
		}
	}
}

sub testBotTool {
	my $msg = shift;
	return unless $msg;
	
	if ( $msg->{action_id}->[0] =~ /BOTTOOL/ ) {
		testSimple($msg, 'NO_DOCS', 'NO_DOCS_BEGIN', 'NO_DOCS_END');
		testSimple($msg, 'NO_DOCS_INIT', 'NO_DOCS_INIT_BEGIN', 'NO_DOCS_INIT_END');
        testSimple($msg, 'SPELL_CHECK', 'SPELL_CHECK_BEGIN', 'SPELL_CHECK_END');
        testSimple($msg, 'PROCESSING', 'PROCESSING_START', 'PROCESSING_END');
	}
}

sub testTemplate {
	my $msg = shift;
	return unless $msg;
	
    if ( $msg->{action_id}->[0] eq 'TemplateAgent' ) {
		my $cl = dclone($msg);
		$cl->{action_id} = [ @{$msg->{action_id}}[1..scalar @{$msg->{action_id}}-1] ];
		testSimple($cl, "TA.".$cl->{action_id}->[0], "start", "end");
	}
    
    if ( $msg->{action_id}->[0] eq 'SolutionsController' ) {
		my $cl = dclone($msg);
		$cl->{action_id} = [ @{$msg->{action_id}}[1..scalar @{$msg->{action_id}}-1] ];
		testSimple($cl, "SC.".$cl->{action_id}->[0], "start", "end");
	}
    
    if ( $msg->{action_id}->[0] eq 'HtmlParserHelper' ) {
		my $cl = dclone($msg);
		$cl->{action_id} = [ @{$msg->{action_id}}[1..scalar @{$msg->{action_id}}-1] ];
		testSimple($cl, "HPH.".$cl->{action_id}->[0], "start", "end");
	}
    
    if ( $msg->{action_id}->[0] eq 'SabioTemplateProvider' ) {
		my $cl = dclone($msg);
		$cl->{action_id} = [ @{$msg->{action_id}}[1..scalar @{$msg->{action_id}}-1] ];
		testSimple($cl, "STP.".$cl->{action_id}->[0], "start", "end");
	}
}


while (<STDIN>) {
	chomp $_;
	my $decomposed = decompose($_);
		
	testBotTool($decomposed);

	testDocumentGridDataChanged($decomposed);
	
	testSolutionsPanel($decomposed);
	testTicketTreePanel($decomposed);
	
	testUserAssign($decomposed);
	testUserAssignUiReady($decomposed);
	
	testQueueRelocate($decomposed);
	testQueueRelocateUiReady($decomposed);
	
	testDocumentSend($decomposed);
	testDocumentSendUiReady($decomposed);
	
	testProcessing($decomposed);
	testQueuePanelLoad($decomposed);
	
	testDocumentSelectedUiReady($decomposed);
	testQueueSelectedUiReady($decomposed);

	testUserController($decomposed);
    
    testTemplate($decomposed);
}

if ( ($ARGV[0] || '') eq 'csv') {
	report_csv();
} else {
	report();
}
