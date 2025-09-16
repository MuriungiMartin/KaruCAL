#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77582 "ACA-Stud. Documents"
{
    Caption = 'DoDocuments';
    DataCaptionFields = "Document Code";
    PageType = CardPart;
    SourceTable = UnknownTable77360;

    layout
    {
        area(content)
        {
            field("Document Code";"Document Code")
            {
                ApplicationArea = Basic;
                Caption = 'Document';
            }
            label(Control1000000005)
            {
                ApplicationArea = Basic;
                ShowCaption = false;
            }
            field(Document_Image;Document_Image)
            {
                ApplicationArea = Basic;
                Caption = 'Image';
                Image = Chart;
            }
        }
    }

    actions
    {
    }
}

