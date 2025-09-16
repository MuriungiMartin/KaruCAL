#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7304 "Get Outbound Source Documents"
{
    Caption = 'Get Outbound Source Documents';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Whse. Pick Request";"Whse. Pick Request")
        {
            DataItemTableView = sorting("Document Type","Document Subtype","Document No.","Location Code") where(Status=const(Released),"Completely Picked"=const(false));
            RequestFilterFields = "Document Type","Document No.";
            column(ReportForNavId_6879; 6879)
            {
            }
            dataitem("Warehouse Shipment Header";"Warehouse Shipment Header")
            {
                DataItemLink = "No."=field("Document No.");
                DataItemTableView = sorting("No.");
                column(ReportForNavId_5944; 5944)
                {
                }
                dataitem("Warehouse Shipment Line";"Warehouse Shipment Line")
                {
                    DataItemLink = "No."=field("No.");
                    DataItemTableView = sorting("No.","Line No.");
                    column(ReportForNavId_6896; 6896)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        ATOLink: Record "Assemble-to-Order Link";
                        ATOAsmLine: Record "Assembly Line";
                    begin
                        if not "Assemble to Order" then begin
                          CalcFields("Pick Qty.","Pick Qty. (Base)");
                          if "Qty. (Base)" > "Qty. Picked (Base)" + "Pick Qty. (Base)" then begin
                            if "Destination Type" = "destination type"::Customer then begin
                              TestField("Destination No.");
                              Cust.Get("Destination No.");
                              Cust.CheckBlockedCustOnDocs(Cust,"Source Document",false,false);
                            end;

                            if WhsePickWkshCreate.FromWhseShptLine(PickWkshTemplate,PickWkshName,"Warehouse Shipment Line") then
                              LineCreated := true;
                          end;
                        end else
                          if ATOLink.AsmExistsForWhseShptLine("Warehouse Shipment Line") then begin
                            ATOAsmLine.SetRange("Document Type",ATOLink."Assembly Document Type");
                            ATOAsmLine.SetRange("Document No.",ATOLink."Assembly Document No.");
                            if ATOAsmLine.FindSet then
                              repeat
                                ProcessAsmLineFromWhseShpt(ATOAsmLine,"Warehouse Shipment Line");
                              until ATOAsmLine.Next = 0;
                          end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Qty. Outstanding",'>0');
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if "Whse. Pick Request"."Document Type" <>
                       "Whse. Pick Request"."document type"::Shipment
                    then
                      CurrReport.Break;
                end;
            }
            dataitem("Whse. Internal Pick Header";"Whse. Internal Pick Header")
            {
                DataItemLink = "No."=field("Document No.");
                DataItemTableView = sorting("No.");
                column(ReportForNavId_7564; 7564)
                {
                }
                dataitem("Whse. Internal Pick Line";"Whse. Internal Pick Line")
                {
                    DataItemLink = "No."=field("No.");
                    DataItemTableView = sorting("No.","Line No.");
                    column(ReportForNavId_3581; 3581)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CalcFields("Pick Qty.","Pick Qty. (Base)");
                        if "Qty. (Base)" > "Qty. Picked (Base)" + "Pick Qty. (Base)" then begin
                          if WhsePickWkshCreate.FromWhseInternalPickLine(
                               PickWkshTemplate,PickWkshName,LocationCode,"Whse. Internal Pick Line")
                          then
                            LineCreated := true;
                        end;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Qty. Outstanding",'>0');
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if "Whse. Pick Request"."Document Type" <> "Whse. Pick Request"."document type"::"Internal Pick" then
                      CurrReport.Break;
                end;
            }
            dataitem("Production Order";"Production Order")
            {
                DataItemLink = Status=field("Document Subtype"),"No."=field("Document No.");
                DataItemTableView = sorting(Status,"No.") where(Status=const(Released));
                column(ReportForNavId_4824; 4824)
                {
                }
                dataitem("Prod. Order Component";"Prod. Order Component")
                {
                    DataItemLink = Status=field(Status),"Prod. Order No."=field("No.");
                    DataItemTableView = sorting(Status,"Prod. Order No.","Prod. Order Line No.","Line No.") where("Flushing Method"=filter(Manual|"Pick + Forward"|"Pick + Backward"),"Planning Level Code"=const(0));
                    column(ReportForNavId_7771; 7771)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        ToBinCode: Code[20];
                    begin
                        if ("Flushing Method" = "flushing method"::"Pick + Forward") and ("Routing Link Code" = '') then
                          CurrReport.Skip;

                        GetLocation("Location Code");
                        ToBinCode := "Bin Code";

                        CalcFields("Pick Qty.");
                        if "Expected Quantity" > "Qty. Picked" + "Pick Qty." then
                          if WhsePickWkshCreate.FromProdOrderCompLine(
                               PickWkshTemplate,PickWkshName,Location.Code,
                               ToBinCode,"Prod. Order Component")
                          then
                            LineCreated := true;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Location Code","Whse. Pick Request"."Location Code");
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if "Whse. Pick Request"."Document Type" <> "Whse. Pick Request"."document type"::Production then
                      CurrReport.Break;
                end;
            }
            dataitem("Assembly Header";"Assembly Header")
            {
                DataItemLink = "Document Type"=field("Document Subtype"),"No."=field("Document No.");
                DataItemTableView = sorting("Document Type","No.") where("Document Type"=const(Order));
                column(ReportForNavId_3252; 3252)
                {
                }
                dataitem("Assembly Line";"Assembly Line")
                {
                    DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                    DataItemTableView = sorting("Document Type","Document No.",Type,"Location Code") where(Type=const(Item));
                    column(ReportForNavId_6911; 6911)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ProcessAsmLineFromAsmLine("Assembly Line");
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange("Location Code","Whse. Pick Request"."Location Code");
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if "Whse. Pick Request"."Document Type" <> "Whse. Pick Request"."document type"::Assembly then
                      CurrReport.Break;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if not HideDialog then
          if not LineCreated then
            Error(Text000);

        Completed := true;
    end;

    trigger OnPreReport()
    begin
        LineCreated := false;
    end;

    var
        Text000: label 'There are no Warehouse Worksheet Lines created.';
        Location: Record Location;
        Cust: Record Customer;
        WhsePickWkshCreate: Codeunit "Whse. Worksheet-Create";
        PickWkshTemplate: Code[10];
        PickWkshName: Code[10];
        LocationCode: Code[10];
        Completed: Boolean;
        LineCreated: Boolean;
        HideDialog: Boolean;


    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;


    procedure NotCancelled(): Boolean
    begin
        exit(Completed);
    end;


    procedure SetPickWkshName(PickWkshTemplate2: Code[10];PickWkshName2: Code[10];LocationCode2: Code[10])
    begin
        PickWkshTemplate := PickWkshTemplate2;
        PickWkshName := PickWkshName2;
        LocationCode := LocationCode2;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Clear(Location)
        else
          if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;

    local procedure IsPickToBeMadeForAsmLine(AsmLine: Record "Assembly Line"): Boolean
    begin
        with AsmLine do begin
          GetLocation("Location Code");

          CalcFields("Pick Qty.");
          if Location."Require Shipment" then
            exit(Quantity > "Qty. Picked" + "Pick Qty.");

          exit("Quantity to Consume" > "Qty. Picked" + "Pick Qty.");
        end;
    end;

    local procedure ProcessAsmLineFromAsmLine(AsmLine: Record "Assembly Line")
    begin
        if IsPickToBeMadeForAsmLine(AsmLine) then
          if WhsePickWkshCreate.FromAssemblyLine(PickWkshTemplate,PickWkshName,AsmLine) then
            LineCreated := true;
    end;

    local procedure ProcessAsmLineFromWhseShpt(AsmLine: Record "Assembly Line";WhseShptLine: Record "Warehouse Shipment Line")
    begin
        if IsPickToBeMadeForAsmLine(AsmLine) then
          if WhsePickWkshCreate.FromAssemblyLineInATOWhseShpt(PickWkshTemplate,PickWkshName,AsmLine,WhseShptLine) then
            LineCreated := true;
    end;
}

