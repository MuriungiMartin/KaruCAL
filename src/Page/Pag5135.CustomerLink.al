#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5135 "Customer Link"
{
    Caption = 'Customer Link';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "Contact Business Relation";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Customer No.';
                    ToolTip = 'Specifies the number assigned to the contact in the Customer, Vendor, or Bank Account table. This field is only valid for contacts recorded as customer, vendor or bank accounts.';
                }
                field(CurrMasterFields;CurrMasterFields)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Current Master Fields';
                    OptionCaption = 'Contact,Customer';
                    ToolTip = 'Specifies which fields should be used to prioritize in case there is conflicting information in fields common to the contact card and the bank account card.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if ("No." <> '') and (CloseAction = Action::LookupOK) then begin
          ContBusRel := Rec;
          ContBusRel.Insert(true);

          case CurrMasterFields of
            Currmasterfields::Contact:
              begin
                Cont.Get(ContBusRel."Contact No.");
                UpdateCustVendBank.UpdateCustomer(Cont,ContBusRel);
              end;
            Currmasterfields::Customer:
              begin
                Cust.Get(ContBusRel."No.");
                UpdateContFromCust.OnModify(Cust);
              end;
          end;
        end;
    end;

    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
        Cust: Record Customer;
        UpdateCustVendBank: Codeunit "CustVendBank-Update";
        UpdateContFromCust: Codeunit "CustCont-Update";
        CurrMasterFields: Option Contact,Customer;
}

