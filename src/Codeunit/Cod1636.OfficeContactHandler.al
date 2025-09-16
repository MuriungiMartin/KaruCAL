#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1636 "Office Contact Handler"
{
    TableNo = "Office Add-in Context";

    trigger OnRun()
    begin
        if Email <> '' then
          RedirectContact(Rec)
        else
          ShowContactSelection(Rec);
    end;

    var
        SelectAContactTxt: label 'Select a contact';

    local procedure RedirectContact(TempOfficeAddinContext: Record "Office Add-in Context" temporary)
    var
        Contact: Record Contact;
        TempOfficeContactAssociations: Record "Office Contact Associations" temporary;
    begin
        if TempOfficeAddinContext."Contact No." <> '' then
          Contact.SetRange("No.",TempOfficeAddinContext."Contact No.")
        else
          Contact.SetRange("Search E-Mail",UpperCase(TempOfficeAddinContext.Email));

        if not Contact.FindFirst then
          Page.Run(Page::"Office New Contact Dlg")
        else
          with TempOfficeContactAssociations do begin
            CollectMultipleContacts(Contact,TempOfficeContactAssociations,TempOfficeAddinContext);
            if (Count > 1) and (TempOfficeAddinContext.Command <> '') then
              SetRange("Associated Table",TempOfficeAddinContext.CommandType);

            if Count = 1 then
              if (Contact.Type = Contact.Type::Person) and (Contact."Company No." = '') then
                Page.Run(Page::"Office No Company Dlg",Contact)
              else
                if FindFirst then
                  ShowCustomerVendor(TempOfficeAddinContext,Contact,"Associated Table",GetContactNo);
            if Count > 1 then
              Page.Run(Page::"Office Contact Associations",TempOfficeContactAssociations);
          end;
    end;


    procedure ShowContactSelection(OfficeAddinContext: Record "Office Add-in Context")
    var
        Contact: Record Contact;
        ContactList: Page "Contact List";
    begin
        FilterContacts(OfficeAddinContext,Contact);
        ContactList.SetTableview(Contact);
        ContactList.LookupMode(true);
        ContactList.Caption(SelectAContactTxt);
        if ContactList.LookupMode then;
        ContactList.Run;
    end;


    procedure ShowCustomerVendor(TempOfficeAddinContext: Record "Office Add-in Context" temporary;Contact: Record Contact;AssociatedTable: Option;LinkNo: Code[20])
    var
        OfficeContactAssociations: Record "Office Contact Associations";
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        case AssociatedTable of
          OfficeContactAssociations."associated table"::Customer:
            begin
              if TempOfficeAddinContext.CommandType = OfficeContactAssociations."associated table"::Vendor then
                Page.Run(Page::"Office No Vendor Dlg",Contact)
              else
                if Customer.Get(LinkNo) then
                  RedirectCustomer(Customer,TempOfficeAddinContext);
              exit;
            end;
          OfficeContactAssociations."associated table"::Vendor:
            begin
              if TempOfficeAddinContext.CommandType = OfficeContactAssociations."associated table"::Customer then
                Page.Run(Page::"Office No Customer Dlg",Contact)
              else
                if Vendor.Get(LinkNo) then
                  RedirectVendor(Vendor,TempOfficeAddinContext);
              exit;
            end;
          else
            if TempOfficeAddinContext.CommandType = OfficeContactAssociations."associated table"::Customer then begin
              Page.Run(Page::"Office No Customer Dlg",Contact);
              exit;
            end;
            if TempOfficeAddinContext.CommandType = OfficeContactAssociations."associated table"::Vendor then begin
              Page.Run(Page::"Office No Vendor Dlg",Contact);
              exit;
            end;
        end;

        Contact.Get(LinkNo);
        Page.Run(Page::"Contact Card",Contact)
    end;

    local procedure CollectMultipleContacts(var Contact: Record Contact;var TempOfficeContactAssociations: Record "Office Contact Associations" temporary;TempOfficeAddinContext: Record "Office Add-in Context" temporary)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        CompanyRecords: Boolean;
    begin
        Contact.SetRange(Type,Contact.Type::Person);
        CompanyRecords := Contact.IsEmpty;
        Contact.SetRange(Type,Contact.Type::Company);
        CompanyRecords := CompanyRecords or (Contact.Count <> 1);
        Contact.SetRange(Type);

        repeat
          ContactBusinessRelation.SetRange("Contact No.",Contact."Company No.");
          if TempOfficeAddinContext.IsAppointment then
            ContactBusinessRelation.SetRange("Link to Table",ContactBusinessRelation."link to table"::Customer);
          if ((Contact.Type = Contact.Type::Person) or CompanyRecords) and
             (Contact."Company No." <> '') and ContactBusinessRelation.FindSet
          then
            repeat
              ContactBusinessRelation.CalcFields("Business Relation Description");
              with TempOfficeContactAssociations do
                if not Get(ContactBusinessRelation."Contact No.",Contact.Type,ContactBusinessRelation."Link to Table") then begin
                  Clear(TempOfficeContactAssociations);
                  Init;
                  TransferFields(ContactBusinessRelation);
                  "Contact Name" := Contact.Name;
                  Type := Contact.Type;
                  "Business Relation Description" := ContactBusinessRelation."Business Relation Description";
                  if "No." = '' then begin
                    "No." := Contact."Company No.";
                    "Associated Table" := "associated table"::Company;
                  end;

                  if ContactBusinessRelation."Link to Table" = TempOfficeAddinContext.CommandType then begin
                    "Contact No." := Contact."No.";
                    "Associated Table" := TempOfficeAddinContext.CommandType;
                  end;
                  Insert;
                end;
            until ContactBusinessRelation.Next = 0
          else
            CreateUnlinkedContactAssociation(TempOfficeContactAssociations,Contact);
        until Contact.Next = 0;
    end;

    local procedure CreateUnlinkedContactAssociation(var TempOfficeContactAssociations: Record "Office Contact Associations" temporary;Contact: Record Contact)
    begin
        Clear(TempOfficeContactAssociations);
        TempOfficeContactAssociations.SetRange("No.",Contact."Company No.");
        if TempOfficeContactAssociations.FindFirst and (TempOfficeContactAssociations.Type = Contact.Type::Company) then
          TempOfficeContactAssociations.Delete;

        if TempOfficeContactAssociations.Count = 0 then begin
          TempOfficeContactAssociations.Init;
          TempOfficeContactAssociations."No." := Contact."Company No.";
          TempOfficeContactAssociations."Contact No." := Contact."No.";
          TempOfficeContactAssociations."Contact Name" := Contact.Name;
          TempOfficeContactAssociations.Type := Contact.Type;
          TempOfficeContactAssociations.Insert;
        end;
        TempOfficeContactAssociations.SetRange("No.");
    end;

    local procedure FilterContacts(OfficeAddinContext: Record "Office Add-in Context";var Contact: Record Contact)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        CompanyNoFilter: Text;
    begin
        with ContactBusinessRelation do
          case true of
            OfficeAddinContext.Command <> '':
              SetRange("Link to Table",OfficeAddinContext.CommandType);
            OfficeAddinContext.IsAppointment:
              SetRange("Link to Table","link to table"::Customer);
            else
              SetFilter("Link to Table",'%1|%2',"link to table"::Customer,"link to table"::Vendor);
          end;

        if ContactBusinessRelation.FindSet then begin
          repeat
            CompanyNoFilter += ContactBusinessRelation."Contact No." + '|';
          until ContactBusinessRelation.Next = 0;
          CompanyNoFilter := DelChr(CompanyNoFilter,'>','|');
          Contact.SetFilter("Company No.",CompanyNoFilter);
        end;
    end;

    local procedure RedirectCustomer(Customer: Record Customer;var TempOfficeAddinContext: Record "Office Add-in Context" temporary)
    var
        OfficeDocumentHandler: Codeunit "Office Document Handler";
    begin
        Page.Run(Page::"Customer Card",Customer);
        OfficeDocumentHandler.HandleSalesCommand(Customer,TempOfficeAddinContext);
    end;

    local procedure RedirectVendor(Vendor: Record Vendor;var TempOfficeAddinContext: Record "Office Add-in Context" temporary)
    var
        OfficeDocumentHandler: Codeunit "Office Document Handler";
    begin
        Page.Run(Page::"Vendor Card",Vendor);
        OfficeDocumentHandler.HandlePurchaseCommand(Vendor,TempOfficeAddinContext);
    end;

    [EventSubscriber(Objecttype::Page, 5052, 'OnClosePageEvent', '', false, false)]
    local procedure OnContactSelected(var Rec: Record Contact)
    var
        TempOfficeAddinContext: Record "Office Add-in Context" temporary;
        OfficeMgt: Codeunit "Office Management";
    begin
        if OfficeMgt.IsAvailable then begin
          OfficeMgt.GetContext(TempOfficeAddinContext);
          if TempOfficeAddinContext.Email = '' then begin
            TempOfficeAddinContext.Name := Rec.Name;
            TempOfficeAddinContext.Email := Rec."E-Mail";
            TempOfficeAddinContext."Contact No." := Rec."No.";
            if not TempOfficeAddinContext.IsAppointment then
              OfficeMgt.AddRecipient(Rec.Name,Rec."E-Mail");
            OfficeMgt.InitializeContext(TempOfficeAddinContext);
          end;
        end;
    end;
}

