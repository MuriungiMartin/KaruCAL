#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51728 "Quatation Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Quatation Summary.rdlc';

    dataset
    {
        dataitem("Purchase Line";"Purchase Line")
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(DocumentNo_PurchaseLine;"Purchase Line"."Document No.")
            {
            }
            column(No_PurchaseLine;"Purchase Line"."No.")
            {
            }
            column(Description_PurchaseLine;"Purchase Line".Description)
            {
            }
            column(Description2_PurchaseLine;"Purchase Line"."Description 2")
            {
            }
            column(UnitofMeasure_PurchaseLine;"Purchase Line"."Unit of Measure")
            {
            }
            column(Quantity_PurchaseLine;"Purchase Line".Quantity)
            {
            }
            column(VDesc1;VDesc[1])
            {
            }
            column(VDesc2;VDesc[2])
            {
            }
            column(VDesc3;VDesc[3])
            {
            }
            column(VDesc4;VDesc[4])
            {
            }
            column(VDesc5;VDesc[5])
            {
            }
            column(VDesc6;VDesc[6])
            {
            }
            column(VDesc7;VDesc[7])
            {
            }
            column(VDesc8;VDesc[8])
            {
            }
            column(VDesc9;VDesc[9])
            {
            }
            column(VDesc10;VDesc[10])
            {
            }
            column(VDesc11;VDesc[11])
            {
            }
            column(V1Desc1;VDesc1[1])
            {
            }
            column(V1Desc2;VDesc1[2])
            {
            }
            column(V1Desc3;VDesc1[3])
            {
            }
            column(V1Desc4;VDesc1[4])
            {
            }
            column(V1Desc5;VDesc1[5])
            {
            }
            column(V1Desc6;VDesc1[6])
            {
            }
            column(V1Desc7;VDesc1[7])
            {
            }
            column(V1Desc8;VDesc1[8])
            {
            }
            column(V1Desc9;VDesc1[9])
            {
            }
            column(V1Desc10;VDesc1[10])
            {
            }
            column(VU1;VU[1])
            {
            }
            column(VU2;VU[2])
            {
            }
            column(VU3;VU[3])
            {
            }
            column(VU4;VU[4])
            {
            }
            column(VU5;VU[5])
            {
            }
            column(VU6;VU[6])
            {
            }
            column(VU7;VU[7])
            {
            }
            column(VU8;VU[8])
            {
            }
            column(VU9;VU[9])
            {
            }
            column(VU10;VU[10])
            {
            }
            column(VP1;VP[1])
            {
            }
            column(VP2;VP[2])
            {
            }
            column(VP3;VP[3])
            {
            }
            column(VP4;VP[4])
            {
            }
            column(VP5;VP[5])
            {
            }
            column(VP6;VP[6])
            {
            }
            column(VP7;VP[7])
            {
            }
            column(VP8;VP[8])
            {
            }
            column(VP9;VP[9])
            {
            }
            column(VP10;VP[10])
            {
            }

            trigger OnAfterGetRecord()
            begin

                  for i:=1 to 10 do begin
                  VU[i]:=0;
                  VP[i]:=0;
                  end;

                  for i:=1 to 10 do begin
                  PLine.Reset;
                  PLine.SetFilter(PLine."Request for Quote No.","Purchase Line".GetFilter("Purchase Line"."Request for Quote No."));
                  PLine.SetRange(PLine."Buy-from Vendor No.",VDesc[i]);
                  PLine.SetRange(PLine."Description 2","Purchase Line"."Description 2");
                  if PLine.Find('-') then begin
                  VU[i]:=PLine."Direct Unit Cost";
                  VP[i]:=PLine."Line Amount";
                  end;
                  end;
            end;

            trigger OnPreDataItem()
            begin

                LastFieldNo := FieldNo("Description 3");

                LastFieldNo := FieldNo("No.");

                PuchH.Reset;
                PuchH.SetFilter(PuchH."Request for Quote No.","Purchase Line".GetFilter("Purchase Line"."Request for Quote No."));
                PuchH.SetRange(PuchH."Document Type",PuchH."document type"::Quote);
                if PuchH.Find('-') then begin
                repeat
                if i<11 then begin
                i:=i+1;
                VDesc[i]:=PuchH."Buy-from Vendor No.";
                if Vend.Get(PuchH."Buy-from Vendor No.") then
                VDesc1[i]:=Vend.Name;
                end;
                until PuchH.Next=0;
                end;

                  PLine.Reset;
                  PLine.SetFilter(PLine."Request for Quote No.","Purchase Line".GetFilter("Purchase Line"."Request for Quote No."));
                  if PLine.Find('-') then begin
                  repeat
                  PLine."Description 3":=CopyStr(PLine."Description 2",1,30);
                  PLine.Modify;
                  until PLine.Next=0;
                  end;
            end;
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

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Vend: Record Vendor;
        VDesc: array [20] of Text[200];
        i: Integer;
        ReqVend: Record UnknownRecord61051;
        VDesc1: array [20] of Text[200];
        VU: array [20] of Decimal;
        VP: array [20] of Decimal;
        PLine: Record "Purchase Line";
        PuchH: Record "Purchase Header";
}

