#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 133 "Inc. Doc. Atts. Ready for OCR"
{
    Caption = 'Inc. Doc. Atts. Ready for OCR';

    elements
    {
        dataitem(Incoming_Document;"Incoming Document")
        {
            DataItemTableFilter = "OCR Status"=const(Ready);
            dataitem(Incoming_Document_Attachment;"Incoming Document Attachment")
            {
                DataItemLink = "Incoming Document Entry No."=Incoming_Document."Entry No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = "Use for OCR"=const(true);
                column(Incoming_Document_Entry_No;"Incoming Document Entry No.")
                {
                }
                column(Line_No;"Line No.")
                {
                }
            }
        }
    }
}

