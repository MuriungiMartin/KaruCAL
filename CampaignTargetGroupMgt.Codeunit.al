#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7030 "Campaign Target Group Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        ContBusRel: Record "Contact Business Relation";
        SegLine: Record "Segment Line";
        CampaignTargetGr: Record "Campaign Target Group";
        Text000: label '%1 %2 is now activated.';
        Text001: label '%1 %2 is now deactivated.';
        Text002: label 'To activate the sales prices and/or line discounts, you must apply the relevant %1(s) to the %2 and place a check mark in the %3 field on the %1.';
        InteractLogEntry: Record "Interaction Log Entry";
        Text004: label 'There are no Sales Prices or Sales Line Discounts currently linked to this %1. Do you still want to activate?';
        Text006: label 'Activating prices for the Contacts...\\';
        Text007: label 'Segment Lines         @1@@@@@@@@@@';
        Text008: label 'Logged Segment Lines  @1@@@@@@@@@@';


    procedure ActivateCampaign(var Campaign: Record Campaign)
    var
        SalesPrice: Record "Sales Price";
        SalesLineDisc: Record "Sales Line Discount";
        Window: Dialog;
        Found: Boolean;
        Continue: Boolean;
        NoOfRecords: Integer;
        i: Integer;
    begin
        SalesPrice.SetCurrentkey("Sales Type","Sales Code");
        SalesPrice.SetRange("Sales Type",SalesPrice."sales type"::Campaign);
        SalesPrice.SetRange("Sales Code",Campaign."No.");
        SalesLineDisc.SetCurrentkey("Sales Type","Sales Code");
        SalesLineDisc.SetRange("Sales Type",SalesLineDisc."sales type"::Campaign);
        SalesLineDisc.SetRange("Sales Code",Campaign."No.");
        if not (SalesPrice.FindFirst or SalesLineDisc.FindFirst) then begin
          Continue := Confirm(Text004,true,Campaign.TableCaption);
          if Continue = false then
            exit;
        end;
        CampaignTargetGr.LockTable;
        Found := false;

        with SegLine do begin
          SetCurrentkey("Campaign No.");
          SetRange("Campaign No.",Campaign."No.");
          SetRange("Campaign Target",true);

          if Find('-') then begin
            Found := true;
            i := 0;
            Window.Open(
              Text006 +
              Text007);
            NoOfRecords := Count;
            repeat
              i := i + 1;
              AddSegLinetoTargetGr(SegLine);
              Window.Update(1,ROUND(i / NoOfRecords * 10000,1));
            until Next = 0;
            Window.Close;
          end;
        end;

        with InteractLogEntry do begin
          SetCurrentkey("Campaign No.","Campaign Target");
          SetRange("Campaign No.",Campaign."No.");
          SetRange("Campaign Target",true);
          SetRange(Postponed,false);
          if Find('-') then begin
            Found := true;
            i := 0;
            Window.Open(
              Text006 +
              Text008);
            NoOfRecords := Count;
            repeat
              i := i + 1;
              AddInteractionLogEntry(InteractLogEntry);
              Window.Update(1,ROUND(i / NoOfRecords * 10000,1));
            until Next = 0;
            Window.Close;
          end;
        end;
        if Found then begin
          Commit;
          Message(Text000,Campaign.TableCaption,Campaign."No.")
        end else
          Error(Text002,SegLine.TableCaption,Campaign.TableCaption,SegLine.FieldCaption("Campaign Target"));
    end;


    procedure DeactivateCampaign(var Campaign: Record Campaign;ShowMessage: Boolean)
    begin
        CampaignTargetGr.LockTable;

        CampaignTargetGr.SetCurrentkey("Campaign No.");
        CampaignTargetGr.SetRange("Campaign No.",Campaign."No.");
        if CampaignTargetGr.Find('-') then
          repeat
            CampaignTargetGr.Delete;
          until CampaignTargetGr.Next = 0;
        if ShowMessage then
          Message(Text001,Campaign.TableCaption,Campaign."No.");
    end;


    procedure AddSegLinetoTargetGr(SegLine: Record "Segment Line")
    begin
        with SegLine do
          if ("Campaign No." <> '') and "Campaign Target" then begin
            ContBusRel.SetCurrentkey("Link to Table","Contact No.");
            ContBusRel.SetRange("Link to Table",ContBusRel."link to table"::Customer);
            ContBusRel.SetRange("Contact No.","Contact Company No.");
            if ContBusRel.FindFirst then
              InsertTargetGroup(CampaignTargetGr.Type::Customer,ContBusRel."No.","Campaign No.")
            else
              InsertTargetGroup(
                CampaignTargetGr.Type::Contact,"Contact Company No.","Campaign No.");
            if CampaignTargetGr.Insert(true) then;
          end;
    end;


    procedure DeleteSegfromTargetGr(SegLine: Record "Segment Line")
    var
        SegLine2: Record "Segment Line";
    begin
        with SegLine do
          if "Campaign No." <> '' then begin
            SegLine2.SetCurrentkey("Campaign No.","Contact Company No.","Campaign Target");
            SegLine2.SetRange("Campaign No.","Campaign No.");
            SegLine2.SetRange("Contact Company No.","Contact Company No.");
            SegLine2.SetRange("Campaign Target",true);

            InteractLogEntry.SetCurrentkey("Campaign No.","Contact Company No.","Campaign Target");
            InteractLogEntry.SetRange("Campaign No.","Campaign No.");
            InteractLogEntry.SetRange("Contact Company No.","Contact Company No.");
            InteractLogEntry.SetRange("Campaign Target",true);
            InteractLogEntry.SetRange(Postponed,false);

            if SegLine2.Count + InteractLogEntry.Count = 1 then begin
              ContBusRel.SetCurrentkey("Link to Table","Contact No.");
              ContBusRel.SetRange("Link to Table",ContBusRel."link to table"::Customer);
              ContBusRel.SetRange("Contact No.","Contact Company No.");

              if ContBusRel.FindFirst then begin
                if CampaignTargetGr.Get(
                     CampaignTargetGr.Type::Customer,ContBusRel."No.","Campaign No.")
                then
                  CampaignTargetGr.Delete;
              end else
                if CampaignTargetGr.Get(
                     CampaignTargetGr.Type::Contact,"Contact No.","Campaign No.")
                then
                  CampaignTargetGr.Delete;
            end;
          end;
    end;

    local procedure AddInteractionLogEntry(InteractionLogEntry: Record "Interaction Log Entry")
    begin
        with InteractionLogEntry do
          if ("Campaign No." <> '') and "Campaign Target" then begin
            ContBusRel.SetCurrentkey("Link to Table","Contact No.");
            ContBusRel.SetRange("Link to Table",ContBusRel."link to table"::Customer);
            ContBusRel.SetRange("Contact No.","Contact Company No.");
            if ContBusRel.FindFirst then
              InsertTargetGroup(CampaignTargetGr.Type::Customer,ContBusRel."No.","Campaign No.")
            else
              InsertTargetGroup(
                CampaignTargetGr.Type::Contact,"Contact Company No.","Campaign No.");
            if CampaignTargetGr.Insert(true) then;
          end;
    end;


    procedure DeleteContfromTargetGr(InteractLogEntry: Record "Interaction Log Entry")
    var
        InteractLogEntry2: Record "Interaction Log Entry";
    begin
        with InteractLogEntry do
          if "Campaign No." <> '' then begin
            InteractLogEntry2.SetCurrentkey("Campaign No.","Contact Company No.","Campaign Target");
            InteractLogEntry2.SetRange("Campaign No.","Campaign No.");
            InteractLogEntry2.SetRange("Contact Company No.","Contact Company No.");
            InteractLogEntry2.SetRange("Campaign Target",true);
            InteractLogEntry2.SetRange(Postponed,false);

            SegLine.SetCurrentkey("Campaign No.","Contact Company No.","Campaign Target");
            SegLine.SetRange("Campaign No.","Campaign No.");
            SegLine.SetRange("Contact Company No.","Contact Company No.");
            SegLine.SetRange("Campaign Target",true);

            if InteractLogEntry2.Count + Count = 1 then begin
              ContBusRel.SetCurrentkey("Link to Table","Contact No.");
              ContBusRel.SetRange("Link to Table",ContBusRel."link to table"::Customer);
              ContBusRel.SetRange("Contact No.","Contact Company No.");

              if ContBusRel.FindFirst then begin
                if CampaignTargetGr.Get(
                     CampaignTargetGr.Type::Customer,ContBusRel."No.","Campaign No.")
                then
                  CampaignTargetGr.Delete;
              end else
                if CampaignTargetGr.Get(
                     CampaignTargetGr.Type::Contact,"Contact No.","Campaign No.")
                then
                  CampaignTargetGr.Delete;
            end;
          end;
    end;


    procedure ConverttoCustomer(Contact: Record Contact;Customer: Record Customer)
    var
        CampaignTargetGr2: Record "Campaign Target Group";
    begin
        with Contact do begin
          CampaignTargetGr2.SetCurrentkey("No.");
          CampaignTargetGr2.SetRange("No.","No.");
          if CampaignTargetGr2.Find('-') then
            repeat
              InsertTargetGroup(
                CampaignTargetGr2.Type::Customer,Customer."No.",CampaignTargetGr2."Campaign No.");
              CampaignTargetGr2.Delete;
            until CampaignTargetGr2.Next = 0;
        end;
    end;


    procedure ConverttoContact(Cust: Record Customer;CompanyContNo: Code[20])
    var
        CampaignTargetGr2: Record "Campaign Target Group";
    begin
        with Cust do begin
          CampaignTargetGr2.SetRange("No.","No.");
          if CampaignTargetGr2.Find('-') then
            repeat
              InsertTargetGroup(
                CampaignTargetGr2.Type::Contact,CompanyContNo,CampaignTargetGr2."Campaign No.");
              CampaignTargetGr2.Delete;
            until CampaignTargetGr2.Next = 0;
        end;
    end;

    local procedure InsertTargetGroup(Type: Option;No: Code[20];CampaignNo: Code[20])
    begin
        CampaignTargetGr.Type := Type;
        CampaignTargetGr."No." := No;
        CampaignTargetGr."Campaign No." := CampaignNo;
        if CampaignTargetGr.Insert then;
    end;
}

