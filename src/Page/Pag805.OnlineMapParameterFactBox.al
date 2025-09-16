#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 805 "Online Map Parameter FactBox"
{
    Caption = 'Online Map Parameter FactBox';
    Editable = false;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            field(Text001;Text001)
            {
                ApplicationArea = Basic,Suite;
                Caption = '{1}';
            }
            field(Text002;Text002)
            {
                ApplicationArea = Basic,Suite;
                Caption = '{2}';
            }
            field(Text003;Text003)
            {
                ApplicationArea = Basic,Suite;
                Caption = '{3}';
            }
            field(Text004;Text004)
            {
                ApplicationArea = Basic,Suite;
                Caption = '{4}';
            }
            field(Text005;Text005)
            {
                ApplicationArea = Basic,Suite;
                Caption = '{5}';
            }
            field(Text006;Text006)
            {
                ApplicationArea = Basic,Suite;
                Caption = '{6}';
            }
            field(Text007;Text007)
            {
                ApplicationArea = Basic,Suite;
                Caption = '{7}';
            }
            field(Text008;Text008)
            {
                ApplicationArea = Basic,Suite;
                Caption = '{8}';
            }
            field(Text009;Text009)
            {
                ApplicationArea = Basic,Suite;
                Caption = '{9}';
            }
            field(LatitudeLbl;LatitudeLbl)
            {
                ApplicationArea = Basic,Suite;
                Caption = '{10}';
            }
            field(LongitudeLbl;LongitudeLbl)
            {
                ApplicationArea = Basic,Suite;
                Caption = '{11}';
            }
        }
    }

    actions
    {
    }

    var
        Text001: label 'Street (Address1)';
        Text002: label 'City';
        Text003: label 'State (County)';
        Text004: label 'ZIP Code/ZIP Code';
        Text005: label 'Country/Region Code';
        Text006: label 'Country/Region Name';
        Text007: label 'Culture Information, e.g., en-us';
        Text008: label 'Distance in (Miles/Kilometers)';
        Text009: label 'Route (Quickest/Shortest)';
        LatitudeLbl: label 'GPS Latitude';
        LongitudeLbl: label 'GPS Longitude';
}

