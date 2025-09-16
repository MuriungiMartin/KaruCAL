#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9017 "Service Technician Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                part(Control1900744308;"Serv Outbound Technician Act.")
                {
                }
            }
            group(Control1900724708)
            {
                part(Control8;"My Job Queue")
                {
                    Visible = false;
                }
                part(Control1907692008;"My Customers")
                {
                }
                part(Control4;"Report Inbox Part")
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
            action("Service &Order")
            {
                ApplicationArea = Basic;
                Caption = 'Service &Order';
                Image = Document;
                RunObject = Report "Service Order";
            }
            action("Service Items Out of &Warranty")
            {
                ApplicationArea = Basic;
                Caption = 'Service Items Out of &Warranty';
                Image = "Report";
                RunObject = Report "Service Items Out of Warranty";
            }
            action("Service Item &Line Labels")
            {
                ApplicationArea = Basic;
                Caption = 'Service Item &Line Labels';
                Image = "Report";
                RunObject = Report "Service Item Line Labels";
            }
            action("Service &Item Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'Service &Item Worksheet';
                Image = ServiceItemWorksheet;
                RunObject = Report "Service Item Worksheet";
            }
        }
        area(embedding)
        {
            action(ServiceOrders)
            {
                ApplicationArea = Basic;
                Caption = 'Service Orders';
                Image = Document;
                RunObject = Page "Service Orders";
            }
            action(ServiceOrdersInProcess)
            {
                ApplicationArea = Basic;
                Caption = 'In Process';
                RunObject = Page "Service Orders";
                RunPageView = where(Status=filter("In Process"));
            }
            action("Service Item Lines")
            {
                ApplicationArea = Basic;
                Caption = 'Service Item Lines';
                RunObject = Page "Service Item Lines";
            }
            action(Customers)
            {
                ApplicationArea = Basic;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page "Customer List";
            }
            action(Loaners)
            {
                ApplicationArea = Basic;
                Caption = 'Loaners';
                Image = Loaners;
                RunObject = Page "Loaner List";
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
        }
        area(sections)
        {
        }
        area(creation)
        {
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
            action(Action3)
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
            action("&Loaner")
            {
                ApplicationArea = Basic;
                Caption = '&Loaner';
                Image = Loaner;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Loaner Card";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            separator(Action7)
            {
                Caption = 'Tasks';
                IsHeader = true;
            }
            action("Service Item &Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'Service Item &Worksheet';
                Image = ServiceItemWorksheet;
                RunObject = Page "Service Item Worksheet";
            }
        }
    }
}

