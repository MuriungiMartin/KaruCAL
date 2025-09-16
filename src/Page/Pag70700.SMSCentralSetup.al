#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70700 "SMS Central Setup"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable70700;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("SMS Code Nos.";"SMS Code Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Client ID";"Client ID")
                {
                    ApplicationArea = Basic;
                }
                field("Batch Nos";"Batch Nos")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if Rec."Setup Nos."='' then begin
         Init;
         if Insert then;
          end;
    end;
}

