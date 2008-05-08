## Controllers

## filters
(TODO) - filters, how the chaining works and :throw

Merb filters are quite powerful, etc.. 

In Rails:

    before_filter :find_post
    after_filter
    
In Merb:

    before :login_required, :exclude => [:index, :show]
    after  :send_email, :only => :create
    
`skip_before` is used to skip a before filter

*Note: it's __exclude__ not except*


(TODO) - how params get passed in controllers
(TODO) - Exception Controller
(TODO) - explain provides
(TODO) - usecase for a part, explain what they are (possibly comments?) - or a side bar of some sorts
(TODO) - Admin controller
(TODO) - specify a layout
(TODO) - rest
(TODO) - content_type
(TODO) - flash?
