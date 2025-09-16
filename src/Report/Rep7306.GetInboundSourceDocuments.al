#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7306 "Get Inbound Source Documents"
{
    Caption = 'Get Inbound Source Documents';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Whse. Put-away Request";"Whse. Put-away Request")
        {
            DataItemTableView = where("Completely Put Away"=const(false));
            RequestFilterFields = "Document Type","Document No.";
            column(ReportForNavId_3390; 3390)
            {
            }
            dataitem("Posted Whse. Receipt Header";"Posted Whse. Receipt Header")
            {
                DataItemLink = "No."=field("Document No.");
                DataItemTableView = sorting("No.");
                column(ReportForNavId_4701; 4701)
                {
                }
                dataitem("Posted Whse. Receipt Line";"Posted Whse. Receipt Line")
                {
                    DataItemLink = "No."=field("No.");
                    DataItemTableView = sorting("No.","Line No.");
                    column(ReportForNavId_7072; 7072)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CalcFields("Put-away Qty.","Put-away Qty. (Base)");
                        if "Qty. (Base)" > "Qty. Put Away (Base)" + "Put-away Qty. (Base)" then begin
                          if WhseWkshCreate.FromWhseRcptLine(
                               WhseWkshTemplateName,WhseWkshName,LocationCode,"Posted Whse. Receipt Line")
                          then
                            LineCreated := true;
                        end;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if "Whse. Put-away Request"."Document Type" <>
                       "Whse. Put-away Request"."document type"::Receipt
                    then
                      CurrReport.Break;
                end;
            }
            dataitem("Whse. Internal Put-away Header";"Whse. Internal Put-away Header")
            {
                DataItemLink = "No."=field("Document No.");
                DataItemTableView = sorting("No.");
                column(ReportForNavId_9282; 9282)
                {
                }
                dataitem("Whse. Internal Put-away Line";"Whse. Internal Put-away Line")
                {
                    DataItemLink = "No."=field("No.");
                    DataItemTableView = sorting("No.","Line No.");
                    column(ReportForNavId_1568; 1568)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CalcFields("Put-away Qty.","Put-away Qty. (Base)");
                        if "Qty. (Base)" > "Qty. Put Away (Base)" + "Put-away Qty. (Base)" then begin
                          if WhseWkshCreate.FromWhseInternalPutawayLine(
                               WhseWkshTemplateName,WhseWkshName,LocationCode,"Whse. Internal Put-away Line")
                          then
                            LineCreated := true;
                        end;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if "Whse. Put-away Request"."Document Type" <>
                       "Whse. Put-away Request"."document type"::"Internal Put-away"
                    then
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
    end;

    trigger OnPreReport()
    begin
        LineCreated := false;
    end;

    var
        Text000: label 'There are no Warehouse Worksheet Lines created.';
        WhseWkshCreate: Codeunit "Whse. Worksheet-Create";
        WhseWkshTemplateName: Code[10];
        WhseWkshName: Code[10];
        LocationCode: Code[10];
        LineCreated: Boolean;
        HideDialog: Boolean;


    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;


    procedure SetWhseWkshName(WhseWkshTemplateName2: Code[10];WhseWkshName2: Code[10];LocationCode2: Code[10])
    begin
        WhseWkshTemplateName := WhseWkshTemplateName2;
        WhseWkshName := WhseWkshName2;
        LocationCode := LocationCode2;
    end;
}

