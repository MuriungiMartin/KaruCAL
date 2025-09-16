#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 684 "Date-Time Dialog"
{
    Caption = 'Date-Time Dialog';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(Date;Date0)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Date';
                ToolTip = 'Specifies the date.';

                trigger OnValidate()
                begin
                    if Time0 = 0T then
                      Time0 := 000000T;
                end;
            }
            field(Time;Time0)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Time';
            }
        }
    }

    actions
    {
    }

    var
        Date0: Date;
        Time0: Time;


    procedure SetDateTime(DateTime: DateTime)
    begin
        Date0 := Dt2Date(DateTime);
        Time0 := Dt2Time(DateTime);
    end;


    procedure GetDateTime(): DateTime
    begin
        exit(CreateDatetime(Date0,Time0));
    end;
}

