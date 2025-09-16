#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7318 "Whse.-Shipment - Create Pick"
{
    Caption = 'Whse.-Shipment - Create Pick';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Warehouse Shipment Line";"Warehouse Shipment Line")
        {
            DataItemTableView = sorting("No.","Line No.");
            column(ReportForNavId_6896; 6896)
            {
            }
            dataitem("Assembly Header";"Assembly Header")
            {
                DataItemTableView = sorting("Document Type","No.");
                column(ReportForNavId_3252; 3252)
                {
                }
                dataitem("Assembly Line";"Assembly Line")
                {
                    DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                    DataItemTableView = sorting("Document Type","Document No.","Line No.");
                    column(ReportForNavId_6911; 6911)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        WMSMgt: Codeunit "WMS Management";
                    begin
                        WMSMgt.CheckInboundBlockedBin("Location Code","Bin Code","No.","Variant Code","Unit of Measure Code");

                        WhseWkshLine.SetRange("Source Line No.","Line No.");
                        if not WhseWkshLine.FindFirst then
                          CreatePick.CreateAssemblyPickLine("Assembly Line")
                        else
                          WhseWkshLineFound := true;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Type,Type::Item);
                        SetFilter("Remaining Quantity (Base)",'>0');

                        WhseWkshLine.SetCurrentkey(
                          "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
                        WhseWkshLine.SetRange("Source Type",Database::"Assembly Line");
                        WhseWkshLine.SetRange("Source Subtype","Assembly Header"."Document Type");
                        WhseWkshLine.SetRange("Source No.","Assembly Header"."No.");
                    end;
                }

                trigger OnPreDataItem()
                var
                    SalesLine: Record "Sales Line";
                begin
                    if not "Warehouse Shipment Line"."Assemble to Order" then
                      CurrReport.Break;

                    SalesLine.Get("Warehouse Shipment Line"."Source Subtype",
                      "Warehouse Shipment Line"."Source No.",
                      "Warehouse Shipment Line"."Source Line No.");
                    SalesLine.AsmToOrderExists("Assembly Header");
                    SetRange("Document Type","Document Type");
                    SetRange("No.","No.");
                end;
            }

            trigger OnAfterGetRecord()
            var
                QtyToPick: Decimal;
                QtyToPickBase: Decimal;
            begin
                if Location."Directed Put-away and Pick" then
                  CheckBin(0,0);

                WhseWkshLine.Reset;
                WhseWkshLine.SetCurrentkey(
                  "Whse. Document Type","Whse. Document No.","Whse. Document Line No.");
                WhseWkshLine.SetRange(
                  "Whse. Document Type",WhseWkshLine."whse. document type"::Shipment);
                WhseWkshLine.SetRange("Whse. Document No.",WhseShptHeader."No.");

                WhseWkshLine.SetRange("Whse. Document Line No.","Line No.");
                if not WhseWkshLine.FindFirst then begin
                  TestField("Qty. per Unit of Measure");
                  CalcFields("Pick Qty. (Base)","Pick Qty.");
                  QtyToPickBase := "Qty. (Base)" - ("Qty. Picked (Base)" + "Pick Qty. (Base)");
                  QtyToPick := Quantity - ("Qty. Picked" + "Pick Qty.");
                  if QtyToPick > 0 then begin
                    if "Destination Type" = "destination type"::Customer then begin
                      TestField("Destination No.");
                      Cust.Get("Destination No.");
                      Cust.CheckBlockedCustOnDocs(Cust,"Source Document",false,false);
                    end;

                    CreatePick.SetWhseShipment(
                      "Warehouse Shipment Line",1,WhseShptHeader."Shipping Agent Code",
                      WhseShptHeader."Shipping Agent Service Code",WhseShptHeader."Shipment Method Code");
                    if not "Assemble to Order" then begin
                      CreatePick.SetTempWhseItemTrkgLine(
                        "No.",Database::"Warehouse Shipment Line",
                        '',0,"Line No.","Location Code");
                      CreatePick.CreateTempLine(
                        "Location Code","Item No.","Variant Code","Unit of Measure Code",
                        '',"Bin Code","Qty. per Unit of Measure",QtyToPick,QtyToPickBase);
                    end;
                  end;
                end else
                  WhseWkshLineFound := true;
            end;

            trigger OnPostDataItem()
            var
                TempWhseItemTrkgLine: Record "Whse. Item Tracking Line" temporary;
                ItemTrackingMgt: Codeunit "Item Tracking Management";
            begin
                CreatePick.ReturnTempItemTrkgLines(TempWhseItemTrkgLine);
                if TempWhseItemTrkgLine.Find('-') then
                  repeat
                    ItemTrackingMgt.CalcWhseItemTrkgLine(TempWhseItemTrkgLine);
                  until TempWhseItemTrkgLine.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                CreatePick.SetValues(
                  AssignedID,1,SortActivity,1,0,0,false,DoNotFillQtytoHandle,BreakbulkFilter,false);

                CopyFilters(WhseShptLine);
                SetFilter("Qty. (Base)",'>0');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AssignedID;AssignedID)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Assigned User ID';
                        TableRelation = "Warehouse Employee";

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            WhseEmployee: Record "Warehouse Employee";
                            LookupWhseEmployee: Page "Warehouse Employee List";
                        begin
                            WhseEmployee.SetCurrentkey("Location Code");
                            WhseEmployee.SetRange("Location Code",Location.Code);
                            LookupWhseEmployee.LookupMode(true);
                            LookupWhseEmployee.SetTableview(WhseEmployee);
                            if LookupWhseEmployee.RunModal = Action::LookupOK then begin
                              LookupWhseEmployee.GetRecord(WhseEmployee);
                              AssignedID := WhseEmployee."User ID";
                            end;
                        end;

                        trigger OnValidate()
                        var
                            WhseEmployee: Record "Warehouse Employee";
                        begin
                            if AssignedID <> '' then
                              WhseEmployee.Get(AssignedID,Location.Code);
                        end;
                    }
                    field(SortingMethodForActivityLines;SortActivity)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sorting Method for Activity Lines';
                        MultiLine = true;
                        OptionCaption = ' ,Item,Document,Shelf or Bin,Due Date,Destination,Bin Ranking,Action Type';
                    }
                    field(BreakbulkFilter;BreakbulkFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Set Breakbulk Filter';
                    }
                    field(DoNotFillQtytoHandle;DoNotFillQtytoHandle)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Do Not Fill Qty. to Handle';
                    }
                    field(PrintDoc;PrintDoc)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Document';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if Location."Use ADCS" then
              DoNotFillQtytoHandle := true;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        WhseActivHeader: Record "Warehouse Activity Header";
        TempWhseItemTrkgLine: Record "Whse. Item Tracking Line" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        CreatePick.CreateWhseDocument(FirstActivityNo,LastActivityNo,true);

        CreatePick.ReturnTempItemTrkgLines(TempWhseItemTrkgLine);
        ItemTrackingMgt.UpdateWhseItemTrkgLines(TempWhseItemTrkgLine);

        WhseActivHeader.SetRange(Type,WhseActivHeader.Type::Pick);
        WhseActivHeader.SetRange("No.",FirstActivityNo,LastActivityNo);
        if WhseActivHeader.Find('-') then begin
          repeat
            if SortActivity > 0 then
              WhseActivHeader.SortWhseDoc;
          until WhseActivHeader.Next = 0;

          if PrintDoc then
            Report.Run(Report::"Picking List",false,false,WhseActivHeader);
        end else
          Error(NothingToHandleErr);
    end;

    trigger OnPreReport()
    begin
        Clear(CreatePick);
        EverythingHandled := true;
    end;

    var
        Location: Record Location;
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseWkshLine: Record "Whse. Worksheet Line";
        Cust: Record Customer;
        CreatePick: Codeunit "Create Pick";
        FirstActivityNo: Code[20];
        LastActivityNo: Code[20];
        AssignedID: Code[50];
        SortActivity: Option " ",Item,Document,"Shelf or Bin","Due Date",Destination,"Bin Ranking","Action Type";
        PrintDoc: Boolean;
        EverythingHandled: Boolean;
        WhseWkshLineFound: Boolean;
        HideValidationDialog: Boolean;
        DoNotFillQtytoHandle: Boolean;
        BreakbulkFilter: Boolean;
        SingleActivCreatedMsg: label '%1 activity no. %2 has been created.%3', Comment='%1=WhseActivHeader.Type;%2=Whse. Activity No.;%3=Concatenates ExpiredItemMessageText';
        SingleActivAndWhseShptCreatedMsg: label '%1 activity no. %2 has been created.\For Warehouse Shipment lines that have existing Pick Worksheet lines, no %3 lines have been created.%4', Comment='%1=WhseActivHeader.Type;%2=Whse. Activity No.;%3=WhseActivHeader.Type;%4=Concatenates ExpiredItemMessageText';
        MultipleActivCreatedMsg: label '%1 activities no. %2 to %3 have been created.%4', Comment='%1=WhseActivHeader.Type;%2=First Whse. Activity No.;%3=Last Whse. Activity No.;%4=Concatenates ExpiredItemMessageText';
        MultipleActivAndWhseShptCreatedMsg: label '%1 activities no. %2 to %3 have been created.\For Warehouse Shipment lines that have existing Pick Worksheet lines, no %4 lines have been created.%5', Comment='%1=WhseActivHeader.Type;%2=First Whse. Activity No.;%3=Last Whse. Activity No.;%4=WhseActivHeader.Type;%5=Concatenates ExpiredItemMessageText';
        NothingToHandleErr: label 'There is nothing to handle.';


    procedure SetWhseShipmentLine(var WhseShptLine2: Record "Warehouse Shipment Line";WhseShptHeader2: Record "Warehouse Shipment Header")
    begin
        WhseShptLine.Copy(WhseShptLine2);
        WhseShptHeader := WhseShptHeader2;
        AssignedID := WhseShptHeader2."Assigned User ID";
        GetLocation(WhseShptLine."Location Code");
    end;


    procedure GetResultMessage(): Boolean
    var
        WhseActivHeader: Record "Warehouse Activity Header";
        ExpiredItemMessageText: Text[100];
    begin
        ExpiredItemMessageText := CreatePick.GetExpiredItemMessage;
        if FirstActivityNo = '' then
          exit(false);

        if not HideValidationDialog then begin
          WhseActivHeader.Type := WhseActivHeader.Type::Pick;
          if WhseWkshLineFound then begin
            if FirstActivityNo = LastActivityNo then
              Message(
                StrSubstNo(
                  SingleActivAndWhseShptCreatedMsg,Format(WhseActivHeader.Type),FirstActivityNo,
                  Format(WhseActivHeader.Type),ExpiredItemMessageText))
            else
              Message(
                StrSubstNo(
                  MultipleActivAndWhseShptCreatedMsg,Format(WhseActivHeader.Type),FirstActivityNo,LastActivityNo,
                  Format(WhseActivHeader.Type),ExpiredItemMessageText));
          end else begin
            if FirstActivityNo = LastActivityNo then
              Message(
                StrSubstNo(SingleActivCreatedMsg,Format(WhseActivHeader.Type),FirstActivityNo,ExpiredItemMessageText))
            else
              Message(
                StrSubstNo(MultipleActivCreatedMsg,Format(WhseActivHeader.Type),
                  FirstActivityNo,LastActivityNo,ExpiredItemMessageText));
          end;
        end;
        exit(EverythingHandled);
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if Location.Code <> LocationCode then begin
          if LocationCode = '' then
            Clear(Location)
          else
            Location.Get(LocationCode);
        end;
    end;


    procedure Initialize(AssignedID2: Code[50];SortActivity2: Option " ",Item,Document,"Shelf/Bin No.","Due Date","Ship-To","Bin Ranking","Action Type";PrintDoc2: Boolean;DoNotFillQtytoHandle2: Boolean;BreakbulkFilter2: Boolean)
    begin
        AssignedID := AssignedID2;
        SortActivity := SortActivity2;
        PrintDoc := PrintDoc2;
        DoNotFillQtytoHandle := DoNotFillQtytoHandle2;
        BreakbulkFilter := BreakbulkFilter2;
    end;
}

