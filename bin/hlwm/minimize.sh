#!/bin/bash

#number=$(herbstclient attr my_minimized_windows)
herbstclient silent set_attr my_minimized_counter 1

herbstclient chain \
  . substitute C my_minimized_counter new_attr int clients.focus.my_minimized_age C \
  . set_attr my_minimized_counter $(($(herbstclient substitute C my_minimized_counter echo C)+1)) \
  . set_attr clients.focus.minimized true
#  . emit_hook UPDATE_HIDDEN

#herbstclient set_attr my_minimized_windows $(($number+1))
#notify-send $(herbstclient attr my_minimized_windows)
