#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1061 "Select Payment Service"
{
    Caption = 'Select Payment Service';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = StandardDialog;
    SourceTable = "Payment Service Setup";

    layout
    {
        area(content)
        {
            repeater(Control3)
            {
                field(Available;Available)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the icon and link to the payment service will be inserted on the outgoing sales document.';

                    trigger OnValidate()
                    begin
                        if not Available then
                          DeselectedValue := true;
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the name of the payment service.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the description of the payment service.';
                }
            }
            field(SetupPaymentServices;SetupPaymentServicesLbl)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'SetupPaymentServices';
                Editable = false;
                ShowCaption = false;

                trigger OnDrillDown()
                begin
                    CurrPage.Close;
                    Page.Run(Page::"Payment Services");
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        TempPaymentServiceSetup: Record "Payment Service Setup" temporary;
    begin
        if CloseAction in [Action::Cancel,Action::LookupCancel] then
          exit;

        if DeselectedValue then
          exit(true);

        TempPaymentServiceSetup.Copy(Rec,true);
        TempPaymentServiceSetup.SetRange(Available,true);
        if not TempPaymentServiceSetup.FindFirst then
          exit(Confirm(NoPaymentServicesSelectedQst));
    end;

    var
        DeselectedValue: Boolean;
        NoPaymentServicesSelectedQst: label 'To enable the payment service for the document, you must select the Available check box.\\Are you sure you want to exit?';
        SetupPaymentServicesLbl: label 'Set Up Payment Services';
}

