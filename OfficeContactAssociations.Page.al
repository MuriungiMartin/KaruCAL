#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1625 "Office Contact Associations"
{
    Caption = 'Office Contact Associations';
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Related Information';
    ShowFilter = false;
    SourceTable = "Office Contact Associations";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Associated Table";"Associated Table")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the table that is associated with the contact, such as Customer, Vendor, Bank Account, or Company.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the contact.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of the contact.';
                }
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the contact, such as company or contact person.';
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the Office contact.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Customer/Vendor")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'C&ustomer/Vendor';
                Image = ContactReference;
                Promoted = true;
                PromotedCategory = Category4;
                ShortCutKey = 'Return';
                ToolTip = 'View the related customer or vendor account that is associated with the current record.';

                trigger OnAction()
                var
                    Contact: Record Contact;
                    TempOfficeAddinContext: Record "Office Add-in Context" temporary;
                    OfficeMgt: Codeunit "Office Management";
                    OfficeContactHandler: Codeunit "Office Contact Handler";
                begin
                    OfficeMgt.GetContext(TempOfficeAddinContext);
                    case "Associated Table" of
                      "associated table"::" ":
                        begin
                          if Contact.Get("Contact No.") then
                            if (Contact."Company No." = '')then
                              Page.Run(Page::"Office No Company Dlg",Contact)
                            else
                              Page.Run(Page::"Contact Card",Contact);
                        end;
                      "associated table"::Company,
                      "associated table"::"Bank Account":
                        begin
                          if Contact.Get("Contact No.") then
                            Page.Run(Page::"Contact Card",Contact)
                        end;
                      else
                        OfficeContactHandler.ShowCustomerVendor(TempOfficeAddinContext,Contact,"Associated Table","No.");
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetName;
    end;

    var
        Name: Text[50];

    local procedure GetName()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Contact: Record Contact;
    begin
        case "Associated Table" of
          "associated table"::Customer:
            begin
              if Customer.Get("No.") then
                Name := Customer.Name;
            end;
          "associated table"::Vendor:
            begin
              if Vendor.Get("No.") then
                Name := Vendor.Name;
            end;
          "associated table"::Company:
            begin
              if Contact.Get("No.") then
                Name := Contact."Company Name";
            end;
          else
            Clear(Name);
        end;
    end;
}

