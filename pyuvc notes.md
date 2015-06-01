#PYUVC Notes
Example

{
'display_name': 'Auto Focus', 

'unit': 	'input_terminal',

'control_id': 	uvc.UVC_CT_FOCUS_AUTO_CONTROL , 

'bit_mask': 	1<<17, 

'offset': 	0 , 

'data_len': 	1 , 

'buffer_len': 	1, 

'min_val': 	0, 

'max_val': 	1, 

'step':		1,

'def_val':	None,

'd_type': 	bool,

'doc': 		'Enable the Auto Focus'

}



##Doubts
The min_val and max_val is not specified in certain cases. What should be done with them in particular?
When the offset is a non zero value what should be the order followed for writing d_type?


