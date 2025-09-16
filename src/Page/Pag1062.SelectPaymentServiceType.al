#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1062 "Select Payment Service Type"
{
    Caption = 'Select Payment Service Type';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = StandardDialog;
    SourceTable = "Payment Service Setup";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control4)
            {
                Editable = false;
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the payment service type.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the description of the payment service.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        OnRegisterPaymentServiceProviders(Rec);
    end;
}

