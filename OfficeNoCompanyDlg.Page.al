#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1605 "Office No Company Dlg"
{
    Caption = 'Do you want to add the contact to a company?';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    SourceTable = Contact;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                InstructionalText = 'This contact has not been associated with a company. To view the customer or vendor dashboard for the add-in, the contact must be associated with a contact company that is created as a customer or a vendor.';
                label(Control7)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'You may link the contact to an existing contact company, create a new contact company, or continue to the contact card for this contact.';
                    HideValue = true;
                }
                field(HideDialog;HideMessage)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Do not show this message again.';
                    ToolTip = 'Specifies to no longer show this message when displaying a contact that is not linked to a company.';
                }
                field(Company;Company)
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    ShowCaption = false;
                    TableRelation = Contact where (Type=const(Company));
                    ToolTip = 'Specifies the company that is linked to the contact.';

                    trigger OnValidate()
                    var
                        ContBusRel: Record "Contact Business Relation";
                    begin
                        Validate("Company Name",Company);
                        Company := "Company Name";
                        Modify;

                        if Company = '' then begin
                          Company := CopyStr(SelectCompanyTxt,1,50);
                          CurrPage.Update;
                        end else begin
                          ContBusRel.Reset;
                          ContBusRel.SetRange("Contact No.","Company No.");
                          ContBusRel.SetFilter("No.",'<>''''');

                          if ContBusRel.Count > 0 then
                            ShowCustVendBank
                          else
                            Page.Run(Page::"Contact Card",Rec);
                        end;
                    end;
                }
                field(CreateContactCompany;NewContactCompanyLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies a new contact company that links to the current contact.';

                    trigger OnDrillDown()
                    var
                        ContactCompany: Record Contact;
                    begin
                        ContactCompany.Init;
                        ContactCompany.Copy(Rec);
                        ContactCompany."No." := '';
                        ContactCompany.Type := ContactCompany.Type::Company;
                        ContactCompany.Insert(true);
                        Commit;
                        if Action::LookupOK = Page.RunModal(Page::"Contact Card",ContactCompany) then begin
                          Validate("Company No.",ContactCompany."No.");
                          Modify(true);
                          Page.Run(Page::"Contact Card",Rec);
                        end else
                          ContactCompany.Delete;
                    end;
                }
                field(ShowContact;StrSubstNo(ShowContactLbl,Name))
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies information about the selected contact.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Contact Card",Rec);
                        if HideMessage then
                          InstructionMgt.DisableMessageForCurrentUser(InstructionMgt.OfficeNoCompanyDlgCode);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
    begin
        Company := CopyStr(SelectCompanyTxt,1,50);
        if not InstructionMgt.IsEnabled(InstructionMgt.OfficeNoCompanyDlgCode) then begin
          Page.Run(Page::"Contact Card",Rec);
          CurrPage.Close;
          OfficeMgt.CurrPageCloseWorkaround;
        end;
    end;

    var
        SelectCompanyTxt: label 'Select a company';
        ShowContactLbl: label 'View the contact card for %1', Comment='%1 = Contact name';
        InstructionMgt: Codeunit "Instruction Mgt.";
        Company: Text[50];
        HideMessage: Boolean;
        NewContactCompanyLbl: label 'Create a new contact company';
}

