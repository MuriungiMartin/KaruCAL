#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5055 "Name Details"
{
    Caption = 'Name Details';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Contact;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Salutation Code";"Salutation Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the salutation code that will be used when you interact with the contact. The salutation code is only used in Word documents. To see a list of the salutation codes already defined, click the field.';
                }
                field("Job Title";"Job Title")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the contact''s job title, and is valid for contact persons only.';
                }
                field(Initials;Initials)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the contact''s initials, when the contact is a person.';
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the contact''s first name and is valid for contact persons only.';
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the contact''s middle name and is valid for contact persons only.';
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the contact''s surname and is valid for contact persons only.';
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the language code for the contact.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Salutations")
            {
                ApplicationArea = Suite;
                Caption = '&Salutations';
                Image = Salutation;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Contact Salutations";
                RunPageLink = "Contact No. Filter"=field("No."),
                              "Salutation Code"=field("Salutation Code");
                ToolTip = 'Edit specific details regarding the contact person''s name, for example the contact''s first name, middle name, surname, title, and so on.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Editable(Type = Type::Person);
    end;
}

