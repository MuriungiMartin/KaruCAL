#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1628 "Office No Vendor Dlg"
{
    Caption = 'Create vendor record?';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = Contact;

    layout
    {
        area(content)
        {
            field("STRSUBSTNO(VendDialogLbl,Name)";StrSubstNo(VendDialogLbl,Name))
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            group(Control2)
            {
                field(CreateVend;StrSubstNo(CreateVendLbl,Name))
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies a new vendor for the contact.';

                    trigger OnDrillDown()
                    begin
                        CreateVendor;
                        CurrPage.Close;
                    end;
                }
                field(ViewVendList;ViewVendListLbl)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies a list of vendors that are available in your company.';

                    trigger OnDrillDown()
                    var
                        Vendor: Record Vendor;
                    begin
                        Page.Run(Page::"Vendor List",Vendor);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        VendDialogLbl: label 'Cannot find an existing vendor that matches the contact %1. Do you want to create a new vendor based on this contact?', Comment='%1 = Contact name';
        CreateVendLbl: label 'Create a vendor record for %1', Comment='%1 = Contact name';
        ViewVendListLbl: label 'View vendor list';
}

