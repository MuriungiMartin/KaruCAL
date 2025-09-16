#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5775 "Whse. Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'The Source Document is not defined.';


    procedure GetSourceDocument(SourceType: Integer;SourceSubtype: Option "0","1","2","3","4","5","6","7","8","9","10"): Integer
    var
        SourceDocument: Option ,"S. Order","S. Invoice","S. Credit Memo","S. Return Order","P. Order","P. Invoice","P. Credit Memo","P. Return Order","Inb. Transfer","Outb. Transfer","Prod. Consumption","Item Jnl.","Phys. Invt. Jnl.","Reclass. Jnl.","Consumption Jnl.","Output Jnl.","BOM Jnl.","Serv. Order","Job Jnl.","Assembly Consumption","Assembly Order";
    begin
        case SourceType of
          Database::"Sales Line":
            case SourceSubtype of
              1:
                exit(Sourcedocument::"S. Order");
              2:
                exit(Sourcedocument::"S. Invoice");
              3:
                exit(Sourcedocument::"S. Credit Memo");
              5:
                exit(Sourcedocument::"S. Return Order");
            end;
          Database::"Purchase Line":
            case SourceSubtype of
              1:
                exit(Sourcedocument::"P. Order");
              2:
                exit(Sourcedocument::"P. Invoice");
              3:
                exit(Sourcedocument::"P. Credit Memo");
              5:
                exit(Sourcedocument::"P. Return Order");
            end;
          Database::"Service Line":
            exit(Sourcedocument::"Serv. Order");
          Database::"Prod. Order Component":
            exit(Sourcedocument::"Prod. Consumption");
          Database::"Assembly Line":
            exit(Sourcedocument::"Assembly Consumption");
          Database::"Assembly Header":
            exit(Sourcedocument::"Assembly Order");
          Database::"Transfer Line":
            case SourceSubtype of
              0:
                exit(Sourcedocument::"Outb. Transfer");
              1:
                exit(Sourcedocument::"Inb. Transfer");
            end;
          Database::"Item Journal Line":
            case SourceSubtype of
              0:
                exit(Sourcedocument::"Item Jnl.");
              1:
                exit(Sourcedocument::"Reclass. Jnl.");
              2:
                exit(Sourcedocument::"Phys. Invt. Jnl.");
              4:
                exit(Sourcedocument::"Consumption Jnl.");
              5:
                exit(Sourcedocument::"Output Jnl.");
            end;
          Database::"Job Journal Line":
            exit(Sourcedocument::"Job Jnl.");
        end;
        Error(Text000);
    end;


    procedure GetSourceType(WhseWkshLine: Record "Whse. Worksheet Line") SourceType: Integer
    begin
        with WhseWkshLine do
          case "Whse. Document Type" of
            "whse. document type"::Receipt:
              SourceType := Database::"Posted Whse. Receipt Line";
            "whse. document type"::Shipment:
              SourceType := Database::"Warehouse Shipment Line";
            "whse. document type"::Production:
              SourceType := Database::"Prod. Order Component";
            "whse. document type"::Assembly:
              SourceType := Database::"Assembly Line";
            "whse. document type"::"Internal Put-away":
              SourceType := Database::"Whse. Internal Put-away Line";
            "whse. document type"::"Internal Pick":
              SourceType := Database::"Whse. Internal Pick Line";
          end;
    end;


    procedure GetOutboundDocLineQtyOtsdg(SourceType: Integer;SourceSubType: Option "0","1","2","3","4","5","6","7","8","9","10";SourceNo: Code[20];SourceLineNo: Integer;SourceSubLineNo: Integer;var QtyOutstanding: Decimal;var QtyBaseOutstanding: Decimal)
    var
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        with WhseShptLine do begin
          SetCurrentkey("Source Type");
          SetRange("Source Type",SourceType);
          SetRange("Source Subtype",SourceSubType);
          SetRange("Source No.",SourceNo);
          SetRange("Source Line No.",SourceLineNo);
          if FindFirst then begin
            CalcSums("Qty. Outstanding (Base)","Qty. Outstanding");
            CalcFields("Pick Qty. (Base)","Pick Qty.");
            QtyOutstanding := "Qty. Outstanding" - "Pick Qty." - "Qty. to Ship";
            QtyBaseOutstanding := "Qty. Outstanding (Base)" - "Pick Qty. (Base)" - "Qty. to Ship (Base)";
          end else
            GetSrcDocLineQtyOutstanding(SourceType,SourceSubType,SourceNo,
              SourceLineNo,SourceSubLineNo,QtyOutstanding,QtyBaseOutstanding);
        end;
    end;

    local procedure GetSrcDocLineQtyOutstanding(SourceType: Integer;SourceSubType: Option "0","1","2","3","4","5","6","7","8","9","10";SourceNo: Code[20];SourceLineNo: Integer;SourceSubLineNo: Integer;var QtyOutstanding: Decimal;var QtyBaseOutstanding: Decimal)
    var
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
        TransferLine: Record "Transfer Line";
        ServiceLine: Record "Service Line";
        ProdOrderComp: Record "Prod. Order Component";
        AssemblyLine: Record "Assembly Line";
        ProdOrderLine: Record "Prod. Order Line";
    begin
        case SourceType of
          Database::"Sales Line":
            if SalesLine.Get(SourceSubType,SourceNo,SourceLineNo) then begin
              QtyOutstanding := SalesLine."Outstanding Quantity";
              QtyBaseOutstanding := SalesLine."Outstanding Qty. (Base)";
            end;
          Database::"Purchase Line":
            if PurchaseLine.Get(SourceSubType,SourceNo,SourceLineNo) then begin
              QtyOutstanding := PurchaseLine."Outstanding Quantity";
              QtyBaseOutstanding := PurchaseLine."Outstanding Qty. (Base)";
            end;
          Database::"Transfer Line":
            if TransferLine.Get(SourceNo,SourceLineNo) then
              case SourceSubType of
                0: // Direction = Outbound
                  begin
                    QtyOutstanding :=
                      ROUND(TransferLine."Whse Outbnd. Otsdg. Qty (Base)" / (QtyOutstanding / QtyBaseOutstanding),0.00001);
                    QtyBaseOutstanding := TransferLine."Whse Outbnd. Otsdg. Qty (Base)";
                  end;
                1: // Direction = Inbound
                  begin
                    QtyOutstanding :=
                      ROUND(TransferLine."Whse. Inbnd. Otsdg. Qty (Base)" / (QtyOutstanding / QtyBaseOutstanding),0.00001);
                    QtyBaseOutstanding := TransferLine."Whse. Inbnd. Otsdg. Qty (Base)";
                  end;
              end;
          Database::"Service Line":
            if ServiceLine.Get(SourceSubType,SourceNo,SourceLineNo) then begin
              QtyOutstanding := ServiceLine."Outstanding Quantity";
              QtyBaseOutstanding := ServiceLine."Outstanding Qty. (Base)";
            end;
          Database::"Prod. Order Component":
            if ProdOrderComp.Get(SourceSubType,SourceNo,SourceLineNo,SourceSubLineNo) then begin
              QtyOutstanding := ProdOrderComp."Remaining Quantity";
              QtyBaseOutstanding := ProdOrderComp."Remaining Qty. (Base)";
            end;
          Database::"Assembly Line":
            if AssemblyLine.Get(SourceSubType,SourceNo,SourceLineNo) then begin
              QtyOutstanding := AssemblyLine."Remaining Quantity";
              QtyBaseOutstanding := AssemblyLine."Remaining Quantity (Base)";
            end;
          Database::"Prod. Order Line":
            if ProdOrderLine.Get(SourceSubType,SourceNo,SourceLineNo) then begin
              QtyOutstanding := ProdOrderLine."Remaining Quantity";
              QtyBaseOutstanding := ProdOrderLine."Remaining Qty. (Base)";
            end;
          else begin
            QtyOutstanding := 0;
            QtyBaseOutstanding := 0;
          end;
        end;
    end;
}

