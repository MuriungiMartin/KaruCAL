#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9016 "Service Dispatcher Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1904652008;"Service Dispatcher Activities")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control21;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1907692008;"My Customers")
                {
                }
                part(Control1905989608;"My Items")
                {
                }
                part(Control31;"Report Inbox Part")
                {
                    Visible = false;
                }
                part(Control1903012608;"Copy Profile")
                {
                    Visible = false;
                }
                systempart(Control1901377608;MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Service Ta&sks")
            {
                ApplicationArea = Basic;
                Caption = 'Service Ta&sks';
                Image = ServiceTasks;
                RunObject = Report "Service Tasks";
            }
            action("Service &Load Level")
            {
                ApplicationArea = Basic;
                Caption = 'Service &Load Level';
                Image = "Report";
                RunObject = Report "Service Load Level";
            }
            action("Resource &Usage")
            {
                ApplicationArea = Basic;
                Caption = 'Resource &Usage';
                Image = "Report";
                RunObject = Report "Service Item - Resource Usage";
            }
            separator(Action9)
            {
            }
            action("Service I&tems Out of Warranty")
            {
                ApplicationArea = Basic;
                Caption = 'Service I&tems Out of Warranty';
                Image = "Report";
                RunObject = Report "Service Items Out of Warranty";
            }
            separator(Action14)
            {
            }
            action("Profit Service &Contracts")
            {
                ApplicationArea = Basic;
                Caption = 'Profit Service &Contracts';
                Image = "Report";
                RunObject = Report "Service Profit (Contracts)";
            }
            action("Profit Service &Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Profit Service &Orders';
                Image = "Report";
                RunObject = Report "Service Profit (Serv. Orders)";
            }
            action("Profit Service &Items")
            {
                ApplicationArea = Basic;
                Caption = 'Profit Service &Items';
                Image = "Report";
                RunObject = Report "Service Profit (Service Items)";
            }
        }
        area(embedding)
        {
            action("Service Contract Quotes")
            {
                ApplicationArea = Basic;
                Caption = 'Service Contract Quotes';
                RunObject = Page "Service Contract Quotes";
            }
            action(ServiceContracts)
            {
                ApplicationArea = Basic;
                Caption = 'Service Contracts';
                Image = ServiceAgreement;
                RunObject = Page "Service Contracts";
            }
            action(ServiceContractsOpen)
            {
                ApplicationArea = Basic;
                Caption = 'Open';
                Image = Edit;
                RunObject = Page "Service Contracts";
                RunPageView = where("Change Status"=filter(Open));
                ShortCutKey = 'Return';
            }
            action("Service Quotes")
            {
                ApplicationArea = Basic;
                Caption = 'Service Quotes';
                Image = Quote;
                RunObject = Page "Service Quotes";
            }
            action("Service Orders")
            {
                ApplicationArea = Basic;
                Caption = 'Service Orders';
                Image = Document;
                RunObject = Page "Service Orders";
            }
            action("Standard Service Codes")
            {
                ApplicationArea = Basic;
                Caption = 'Standard Service Codes';
                Image = ServiceCode;
                RunObject = Page "Standard Service Codes";
            }
            action(Loaners)
            {
                ApplicationArea = Basic;
                Caption = 'Loaners';
                Image = Loaners;
                RunObject = Page "Loaner List";
            }
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action("Service Items")
            {
                ApplicationArea = Basic;
                Caption = 'Service Items';
                Image = ServiceItem;
                RunObject = Page "Service Item List";
            }
            action(Items)
            {
                ApplicationArea = Basic;
                Caption = 'Items';
                Image = Item;
                RunObject = Page "Item List";
            }
            action("Item Journals")
            {
                ApplicationArea = Basic;
                Caption = 'Item Journals';
                RunObject = Page "Item Journal Batches";
                RunPageView = where("Template Type"=const(Item),
                                    Recurring=const(false));
            }
            action("Requisition Worksheets")
            {
                ApplicationArea = Basic;
                Caption = 'Requisition Worksheets';
                RunObject = Page "Req. Wksh. Names";
                RunPageView = where("Template Type"=const("Req."),
                                    Recurring=const(false));
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                action("Posted Service Shipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Service Shipments';
                    Image = PostedShipment;
                    RunObject = Page "Posted Service Shipments";
                }
                action("Posted Service Invoices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Service Invoices';
                    Image = PostedServiceOrder;
                    RunObject = Page "Posted Service Invoices";
                }
                action("Posted Service Credit Memos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posted Service Credit Memos';
                    RunObject = Page "Posted Service Credit Memos";
                }
            }
        }
        area(creation)
        {
            group("&Service")
            {
                Caption = '&Service';
                Image = Tools;
                action("Change Password")
                {
                    ApplicationArea = Basic;
                    Caption = 'Change Password';
                    Image = ChangeStatus;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Change Password";
                }
                action("Service Contract &Quote")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Contract &Quote';
                    Image = AgreementQuote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Contract Quote";
                    RunPageMode = Create;
                }
                action("Service &Contract")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service &Contract';
                    Image = Agreement;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Contract";
                    RunPageMode = Create;
                }
                action("Service Q&uote")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Q&uote';
                    Image = Quote;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Quote";
                    RunPageMode = Create;
                }
                action("Service &Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service &Order';
                    Image = Document;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Service Order";
                    RunPageMode = Create;
                }
            }
            action("Sales Or&der")
            {
                ApplicationArea = Basic;
                Caption = 'Sales Or&der';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Sales Order";
                RunPageMode = Create;
            }
            action("Transfer &Order")
            {
                ApplicationArea = Basic;
                Caption = 'Transfer &Order';
                Image = Document;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Transfer Order";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Action19)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Service Tas&ks")
            {
                ApplicationArea = Basic;
                Caption = 'Service Tas&ks';
                Image = ServiceTasks;
                RunObject = Page "Service Tasks";
            }
            action("C&reate Contract Service Orders")
            {
                ApplicationArea = Basic;
                Caption = 'C&reate Contract Service Orders';
                Image = "Report";
                RunObject = Report "Create Contract Service Orders";
            }
            action("Create Contract In&voices")
            {
                ApplicationArea = Basic;
                Caption = 'Create Contract In&voices';
                Image = "Report";
                RunObject = Report "Create Contract Invoices";
            }
            action("Post &Prepaid Contract Entries")
            {
                ApplicationArea = Basic;
                Caption = 'Post &Prepaid Contract Entries';
                Image = "Report";
                RunObject = Report "Post Prepaid Contract Entries";
            }
            separator(Action27)
            {
            }
            action("Order Pla&nning")
            {
                ApplicationArea = Basic;
                Caption = 'Order Pla&nning';
                Image = Planning;
                RunObject = Page "Order Planning";
            }
            separator(Action30)
            {
                Caption = 'Administration';
                IsHeader = true;
            }
            action("St&andard Service Codes")
            {
                ApplicationArea = Basic;
                Caption = 'St&andard Service Codes';
                Image = ServiceCode;
                RunObject = Page "Standard Service Codes";
            }
            action("Dispatch Board")
            {
                ApplicationArea = Basic;
                Caption = 'Dispatch Board';
                Image = ListPage;
                RunObject = Page "Dispatch Board";
            }
            separator(Action34)
            {
                Caption = 'History';
                IsHeader = true;
            }
            action("Item &Tracing")
            {
                ApplicationArea = Basic;
                Caption = 'Item &Tracing';
                Image = ItemTracing;
                RunObject = Page "Item Tracing";
            }
            action("Navi&gate")
            {
                ApplicationArea = Basic;
                Caption = 'Navi&gate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
    }
}

