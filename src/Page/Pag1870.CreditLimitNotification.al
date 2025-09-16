#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1870 "Credit Limit Notification"
{
    Caption = 'Credit Limit Notification';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Manage,Create';
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            label(Control4)
            {
                ApplicationArea = Basic,Suite;
                CaptionClass = Heading;
                MultiLine = true;
                ToolTip = 'Specifies the main message of the notification.';
            }
            part(CreditLimitDetails;"Credit Limit Details")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "No."=field("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Manage")
            {
                Caption = '&Manage';
                action(Customer)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter"=field("Global Dimension 2 Filter");
                    RunPageMode = View;
                    ToolTip = 'View details for the customer';
                }
            }
            group(Create)
            {
                Caption = 'Create';
                action(NewFinanceChargeMemo)
                {
                    AccessByPermission = TableData "Finance Charge Memo Header"=RIM;
                    ApplicationArea = Basic;
                    Caption = 'Finance Charge Memo';
                    Image = FinChargeMemo;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedOnly = true;
                    RunObject = Page "Finance Charge Memo";
                    RunPageLink = "Customer No."=field("No.");
                    RunPageMode = Create;
                    ToolTip = 'Create a finance charge memo for the customer.';
                }
            }
            group("Report")
            {
                Caption = 'Report';
                action("Report Customer - Balance to Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer - Balance to Date';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedOnly = true;
                    ToolTip = 'View a list with customers'' payment history up until a certain date. You can use the report to extract your total sales income at the close of an accounting period or fiscal year.';

                    trigger OnAction()
                    var
                        CustomerCard: Page "Customer Card";
                    begin
                        CustomerCard.RunReport(Report::"Customer - Balance to Date","No.");
                    end;
                }
            }
        }
    }

    var
        Heading: Text[250];


    procedure SetHeading(Value: Text[250])
    begin
        Heading := Value;
    end;


    procedure InitializeFromNotificationVar(CreditLimitNotification: Notification)
    var
        Customer: Record Customer;
    begin
        Get(CreditLimitNotification.GetData(Customer.FieldName("No.")));
        SetRange("No.","No.");

        if GetFilter("Date Filter") = '' then
          SetFilter("Date Filter",'..%1',WorkDate);

        CurrPage.CreditLimitDetails.Page.InitializeFromNotificationVar(CreditLimitNotification);
    end;
}

