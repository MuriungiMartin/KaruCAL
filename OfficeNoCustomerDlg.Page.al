#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1627 "Office No Customer Dlg"
{
    Caption = 'Create customer record?';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = Contact;

    layout
    {
        area(content)
        {
            field("STRSUBSTNO(CustDialogLbl,Name)";StrSubstNo(CustDialogLbl,Name))
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            group(Control2)
            {
                field(CreateCust;StrSubstNo(CreateCustLbl,Name))
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies a new customer for the contact.';

                    trigger OnDrillDown()
                    begin
                        CreateCustomer(ChooseCustomerTemplate);
                        CurrPage.Close;
                    end;
                }
                field(ViewCustList;ViewCustListLbl)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies a list of customers that are available in your company.';

                    trigger OnDrillDown()
                    var
                        Customer: Record Customer;
                    begin
                        Page.Run(Page::"Customer List",Customer);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        CustDialogLbl: label 'Cannot find an existing customer that matches the contact %1. Do you want to create a new customer based on this contact?', Comment='%1 = Contact name';
        CreateCustLbl: label 'Create a customer record for %1', Comment='%1 = Contact name';
        ViewCustListLbl: label 'View customer list';
}

