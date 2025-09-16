#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5134 "Contact Duplicates"
{
    ApplicationArea = Basic;
    Caption = 'Contact Duplicates';
    DataCaptionFields = "Contact No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Contact Duplicate";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the contact for which a duplicate has been found.';
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the contact for which a duplicate has been found.';
                }
                field("Duplicate Contact No.";"Duplicate Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contact number of the duplicate that was found.';
                }
                field("Duplicate Contact Name";"Duplicate Contact Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    DrillDownPageID = "Contact Card";
                    ToolTip = 'Specifies the name of the contact that has been identified as a possible duplicate.';
                }
                field("Separate Contacts";"Separate Contacts")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the two contacts are not true duplicates, but separate contacts.';

                    trigger OnValidate()
                    begin
                        SeparateContactsOnAfterValidat;
                    end;
                }
            }
            group(Control18)
            {
                fixed(Control1902205101)
                {
                    group(Address)
                    {
                        Caption = 'Address';
                        field("Cont.Address";Cont.Address)
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'Contact';
                            Editable = false;
                            ToolTip = 'Specifies the contact.';
                        }
                        field("Cont2.Address";Cont2.Address)
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'Duplicate';
                            Editable = false;
                            ToolTip = 'Specifies information for the duplicate.';
                        }
                    }
                    group("ZIP Code")
                    {
                        Caption = 'ZIP Code';
                        field("Cont.""Post Code""";Cont."Post Code")
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'ZIP Code';
                            Editable = false;
                            ToolTip = 'Specifies the ZIP code of the contact duplicate.';
                        }
                        field("Cont2.""Post Code""";Cont2."Post Code")
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'ZIP Code';
                            Editable = false;
                            ToolTip = 'Specifies the ZIP code of the contact duplicate.';
                        }
                    }
                    group(City)
                    {
                        Caption = 'City';
                        field("Cont.City";Cont.City)
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'City';
                            Editable = false;
                            ToolTip = 'Specifies the city of the contact duplicate.';
                        }
                        field("Cont2.City";Cont2.City)
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'City';
                            Editable = false;
                            ToolTip = 'Specifies the city of the contact duplicate.';
                        }
                    }
                    group("Phone No.")
                    {
                        Caption = 'Phone No.';
                        field("Cont.""Phone No.""";Cont."Phone No.")
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'Phone No.';
                            Editable = false;
                            ToolTip = 'Specifies the phone number of the contact duplicate.';
                        }
                        field("Cont2.""Phone No.""";Cont2."Phone No.")
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'Phone No.';
                            Editable = false;
                            ToolTip = 'Specifies the phone number of the contact duplicate.';
                        }
                    }
                    group("Tax Registration No.")
                    {
                        Caption = 'Tax Registration No.';
                        field("Cont.""VAT Registration No.""";Cont."VAT Registration No.")
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'Tax Registration No.';
                            Editable = false;
                            ToolTip = 'Specifies the tax registration number of the contact duplicate.';
                        }
                        field("Cont2.""VAT Registration No.""";Cont2."VAT Registration No.")
                        {
                            ApplicationArea = RelationshipMgmt;
                            Caption = 'Tax Registration No.';
                            Editable = false;
                            ToolTip = 'Specifies the tax registration number of the contact duplicate.';
                        }
                    }
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
    }

    trigger OnAfterGetCurrRecord()
    begin
        Cont.Get("Contact No.");
        Cont2.Get("Duplicate Contact No.");
    end;

    var
        Cont: Record Contact;
        Cont2: Record Contact;

    local procedure SeparateContactsOnAfterValidat()
    begin
        CurrPage.Update;
    end;
}

