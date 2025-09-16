#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10 "Countries/Regions"
{
    ApplicationArea = Basic;
    Caption = 'Countries/Regions';
    PageType = List;
    SourceTable = "Country/Region";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field("Address Format";"Address Format")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the format of the address, which is used on printouts.';
                }
                field("Contact Address Format";"Contact Address Format")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies where you want the contact name to appear in mailing addresses.';
                }
                field("EU Country/Region Code";"EU Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the EU code for the country/region you are doing business with.';
                    Visible = false;
                }
                field("Intrastat Code";"Intrastat Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an INTRASTAT code for the country/region you are trading with.';
                    Visible = false;
                }
                field("VAT Scheme";"VAT Scheme")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the national body that issues the Tax registration number for the country/region in connection with electronic document sending.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Country/Region")
            {
                Caption = '&Country/Region';
                Image = CountryRegion;
                action("Tax Reg. No. Formats")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Reg. No. Formats';
                    Image = NumberSetup;
                    RunObject = Page "VAT Registration No. Formats";
                    RunPageLink = "Country/Region Code"=field(Code);
                    ToolTip = 'Specify that the tax registration number for an account, such as a customer, corresponds to the standard format for tax registration numbers in an account’s country/region.';
                }
            }
        }
    }
}

