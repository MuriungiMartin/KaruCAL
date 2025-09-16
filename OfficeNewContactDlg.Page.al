#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1604 "Office New Contact Dlg"
{
    Caption = 'Do you want to add a new contact?';
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = Contact;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                InstructionalText = 'The sender of this email is not among your contacts.';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Rows;
                field(NewContact;StrSubstNo(CreateContactLbl,TempOfficeAddinContext.Name))
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies a new contact.';

                    trigger OnDrillDown()
                    var
                        TempContact: Record Contact temporary;
                        Contact: Record Contact;
                        NameLength: Integer;
                    begin
                        Contact.SetRange("Search E-Mail",TempOfficeAddinContext.Email);
                        if not Contact.FindFirst then begin
                          NameLength := 50;
                          if StrPos(TempOfficeAddinContext.Name,' ') = 0 then
                            NameLength := 30;
                          TempContact.Init;
                          TempContact.Validate(Type,Contact.Type::Person);
                          TempContact.Validate(Name,CopyStr(TempOfficeAddinContext.Name,1,NameLength));
                          TempContact.Validate("E-Mail",TempOfficeAddinContext.Email);
                          TempContact.Insert;
                          Commit;
                        end;

                        if Action::LookupOK = Page.RunModal(Page::"Office Contact Details Dlg",TempContact) then begin
                          Clear(Contact);
                          Contact.TransferFields(TempContact);
                          Contact.Insert(true);
                          Commit;
                          if NotLinked(Contact) then
                            Page.Run(Page::"Contact Card",Contact)
                          else
                            Contact.ShowCustVendBank;
                          CurrPage.Close;
                        end;
                    end;
                }
                field(LinkContact;LinkContactLbl)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies the contacts in your company.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Contact List");
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
        OfficeMgt.GetContext(TempOfficeAddinContext);
    end;

    var
        CreateContactLbl: label 'Add %1 as a contact', Comment='%1 = Contact name';
        LinkContactLbl: label 'View existing contacts';
        TempOfficeAddinContext: Record "Office Add-in Context" temporary;

    local procedure NotLinked(Contact: Record Contact): Boolean
    var
        ContBusRel: Record "Contact Business Relation";
    begin
        ContBusRel.SetRange("Contact No.",Contact."Company No.");
        ContBusRel.SetFilter("No.",'<>''''');
        exit((Contact."Company No." = '') or ContBusRel.IsEmpty);
    end;
}

