#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68070 "PRL-Journal Mapping"
{
    PageType = Card;
    SourceTable = UnknownTable61098;

    layout
    {
        area(content)
        {
            field("Transaction Code";"Transaction Code")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field("GL Navision";"GL Navision")
            {
                ApplicationArea = Basic;
                Editable = true;
            }
            field("GL Others";"GL Others")
            {
                ApplicationArea = Basic;
                Caption = 'GL (Other FMS)';
            }
            field("Append StaffCode";"Append StaffCode")
            {
                ApplicationArea = Basic;
            }
            field("Amount (Dr/Cr)";"Amount (Dr/Cr)")
            {
                ApplicationArea = Basic;
            }
            field(Analysis0;Analysis0)
            {
                ApplicationArea = Basic;
                Caption = 'Analysis 0';
            }
            field(Analysis1;Analysis1)
            {
                ApplicationArea = Basic;
                Caption = 'Analysis 1';
            }
            field(Analysis2;Analysis2)
            {
                ApplicationArea = Basic;
                Caption = 'Analysis 2';
            }
            field(Analysis3;Analysis3)
            {
                ApplicationArea = Basic;
                Caption = 'Analysis 3';
            }
            field(Analysis4;Analysis4)
            {
                ApplicationArea = Basic;
                Caption = 'Analysis 4';
            }
            field(Analysis5;Analysis5)
            {
                ApplicationArea = Basic;
                Caption = 'Analysis 5';
            }
        }
    }

    actions
    {
    }
}

