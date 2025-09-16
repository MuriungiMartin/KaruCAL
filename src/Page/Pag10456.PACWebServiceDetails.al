#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10456 "PAC Web Service Details"
{
    Caption = 'PAC Web Service Details';
    DelayedInsert = true;
    PageType = List;
    SourceTable = UnknownTable10001;

    layout
    {
        area(content)
        {
            repeater(Control1020000)
            {
                field(Environment;Environment)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the web service is for a test environment or a production environment.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the web service is for requesting digital stamps or for canceling signed invoices.';
                }
                field("Method Name";"Method Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the web method that will be used for this request type. Contact your authorized service provider, PAC, for this information.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the web method URL used for this type of request. Contact your authorized service provider, PAC, for this information.';
                }
            }
        }
    }

    actions
    {
    }
}

