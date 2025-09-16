#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70000 "Update Postings"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("General Posting Setup";"General Posting Setup")
        {
            DataItemTableView = where("Gen. Prod. Posting Group"=filter(<>'RAW MAT'));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "General Posting Setup"."Sales Account":=recs."Sales Account";
                "General Posting Setup"."Sales Line Disc. Account":=recs."Sales Line Disc. Account";
                "General Posting Setup"."Sales Inv. Disc. Account":=recs."Sales Inv. Disc. Account";
                "General Posting Setup"."Sales Pmt. Disc. Debit Acc.":=recs."Sales Pmt. Disc. Debit Acc.";
                "General Posting Setup"."Purch. Account":=recs."Purch. Account";
                "General Posting Setup"."Purch. Line Disc. Account":=recs."Purch. Line Disc. Account";
                "General Posting Setup"."Purch. Inv. Disc. Account":=recs."Purch. Inv. Disc. Account";
                "General Posting Setup"."Purch. Pmt. Disc. Credit Acc.":=recs."Purch. Pmt. Disc. Credit Acc.";
                "General Posting Setup"."COGS Account":=recs."COGS Account";
                "General Posting Setup"."Inventory Adjmt. Account":=recs."Inventory Adjmt. Account";
                "General Posting Setup"."Sales Credit Memo Account":=recs."Sales Credit Memo Account";
                "General Posting Setup"."Purch. Credit Memo Account":=recs."Purch. Credit Memo Account";
                "General Posting Setup"."Sales Pmt. Disc. Credit Acc.":=recs."Sales Pmt. Disc. Credit Acc.";
                "General Posting Setup"."Purch. Pmt. Disc. Debit Acc.":=recs."Purch. Pmt. Disc. Debit Acc.";
                "General Posting Setup"."Sales Pmt. Tol. Debit Acc.":=recs."Sales Pmt. Tol. Debit Acc.";
                "General Posting Setup"."Sales Pmt. Tol. Credit Acc.":=recs."Sales Pmt. Tol. Credit Acc.";
                "General Posting Setup"."Purch. Pmt. Tol. Debit Acc.":=recs."Purch. Pmt. Tol. Debit Acc.";
                "General Posting Setup"."Purch. Pmt. Tol. Credit Acc.":=recs."Purch. Pmt. Tol. Credit Acc.";
                "General Posting Setup"."Sales Prepayments Account":=recs."Sales Prepayments Account";
                "General Posting Setup"."Purch. Prepayments Account":=recs."Purch. Prepayments Account";
                "General Posting Setup"."Purch. FA Disc. Account":=recs."Purch. FA Disc. Account";
                "General Posting Setup"."Invt. Accrual Acc. (Interim)":=recs."Invt. Accrual Acc. (Interim)";
                "General Posting Setup"."COGS Account (Interim)":=recs."COGS Account (Interim)";
                "General Posting Setup"."Direct Cost Applied Account":=recs."Direct Cost Applied Account";
                "General Posting Setup"."Overhead Applied Account":=recs."Overhead Applied Account";
                "General Posting Setup"."Purchase Variance Account":=recs."Purchase Variance Account";
                "General Posting Setup".Modify;
            end;

            trigger OnPreDataItem()
            begin
                recs.Reset;
                recs.SetFilter(recs."Gen. Prod. Posting Group",'=%1','RAW MAT');
                if recs.Find('-') then begin

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
        recs: Record "General Posting Setup";
}

