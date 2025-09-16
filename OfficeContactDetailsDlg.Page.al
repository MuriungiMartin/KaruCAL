#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1630 "Office Contact Details Dlg"
{
    Caption = 'Create New Contact';
    PageType = StandardDialog;
    SourceTable = Contact;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control7)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the contact. If the contact is a person, you can click the field to see the Name Details window.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = false;
                    ToolTip = 'Specifies the email address of the contact.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of contact, either company or person.';

                    trigger OnValidate()
                    begin
                        AssociateToCompany := Type = Type::Person;
                        AssociateEnabled := Type = Type::Person;
                        if Type = Type::Company then begin
                          Clear("Company No.");
                          Clear("Company Name");
                        end;
                    end;
                }
                field("Associate to Company";AssociateToCompany)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Associate to Company';
                    Enabled = AssociateEnabled;
                    ToolTip = 'Specifies whether the contact is associated with a company.';

                    trigger OnValidate()
                    begin
                        if not AssociateToCompany then begin
                          Clear("Company No.");
                          Clear("Company Name");
                        end;
                    end;
                }
                field("Company Name";"Company Name")
                {
                    ApplicationArea = Basic,Suite;
                    AssistEdit = true;
                    Caption = 'Company';
                    Enabled = AssociateToCompany;
                    ToolTip = 'Specifies the name of the company. If the contact is a person, it specifies the name of the company for which this contact works.';

                    trigger OnAssistEdit()
                    begin
                        LookupCompany;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        AssociateToCompany := Type = Type::Person;
        AssociateEnabled := AssociateToCompany;
    end;

    var
        AssociateEnabled: Boolean;
        AssociateToCompany: Boolean;
}

