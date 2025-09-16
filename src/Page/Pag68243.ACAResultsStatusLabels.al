#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68243 "ACA-Results Status Labels"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Document;
    SourceTable = UnknownTable61382;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Current;Current)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Allow View of Transcripts";"Allow View of Transcripts")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
            group(Lubric)
            {
                Caption = 'Lubric Details';
                part(Control1000000000;"ACA-Results Status List")
                {
                    SubPageLink = "Academic Year"=field(Code);
                }
            }
        }
    }

    actions
    {
    }
}

