#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 130 "Posted Docs. With No Inc. Doc."
{
    Caption = 'Posted Docs. With No Inc. Doc.';

    elements
    {
        dataitem(G_L_Entry;"G/L Entry")
        {
            filter(GLAccount;"G/L Account No.")
            {
            }
            column(PostingDate;"Posting Date")
            {
            }
            column(DocumentNo;"Document No.")
            {
            }
            column(ExternalDocumentNo;"External Document No.")
            {
            }
            column(DebitAmount;"Debit Amount")
            {
                Method = Sum;
            }
            column(CreditAmount;"Credit Amount")
            {
                Method = Sum;
            }
            column(NoOfEntries)
            {
                Method = Count;
            }
            dataitem(Incoming_Document;"Incoming Document")
            {
                DataItemLink = "Document No."=G_L_Entry."Document No.","Posting Date"=G_L_Entry."Posting Date";
                column(NoOfIncomingDocuments)
                {
                    ColumnFilter = NoOfIncomingDocuments=const(0);
                    Method = Count;
                }
            }
        }
    }
}

