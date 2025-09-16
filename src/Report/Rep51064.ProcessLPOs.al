#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51064 "Process LPOs"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61831;UnknownTable61831)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                     if not Vend.Get("PRC-LPOs"."supplier id")  then begin
                     Vend.Init;
                     Vend."No.":="PRC-LPOs"."supplier id";
                     Vend."Vendor Posting Group":='NORMAL';
                     Vend."Gen. Bus. Posting Group":='LOCAL';
                     Vend.Insert;
                     end;
                     PurchH.Reset;
                     PurchH.SetRange(PurchH."No.","PRC-LPOs".number);
                     if not PurchH.Find('-') then begin
                     PurchH.Init;
                     PurchH."Document Type":=PurchH."document type"::Order;
                     PurchH."No.":="PRC-LPOs".number;
                     PurchH."Buy-from Vendor No.":="PRC-LPOs"."supplier id";
                     PurchH.Validate(PurchH."Buy-from Vendor No.");
                     PurchH."Shortcut Dimension 2 Code":=Format("PRC-LPOs".dept);

                     PurchH.Insert;
                     end;
                     PurchL.Init;
                     PurchL."Document Type":=PurchL."document type"::Order;
                     PurchL."Document No.":="PRC-LPOs".number;
                     PurchL."Line No.":="PRC-LPOs".id;
                     PurchL."Buy-from Vendor No.":="PRC-LPOs"."supplier id";
                     if Item.Get("PRC-LPOs"."item code") then begin
                     PurchL.Type:=PurchL.Type::Item;
                     PurchL."No.":="PRC-LPOs"."item code";
                   //  PurchL.VALIDATE(PurchL."No.")
                     end;
                     PurchL.Description:=CopyStr("PRC-LPOs"."supplier name",1,40);
                     PurchL."Description 2":= "PRC-LPOs"."supplier name";
                     PurchL."Unit of Measure":=CopyStr("PRC-LPOs".Unit,1,10);
                     PurchL.Quantity:="PRC-LPOs".Quantity;
                     PurchL."Direct Unit Cost":="PRC-LPOs".rate;
                     PurchL.Amount:="PRC-LPOs".Quantity*"PRC-LPOs".rate;
                     PurchL.Insert;
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
        PurchH: Record "Purchase Header";
        PurchL: Record "Purchase Line";
        Item: Record Item;
        Vend: Record Vendor;
}

