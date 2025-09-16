#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10079 "UPS COD Tags"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/UPS COD Tags.rdlc';
    Caption = 'UPS COD Tags';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Sales Invoice Header";"Sales Invoice Header")
        {
            DataItemTableView = sorting("Order No.","No.");
            RequestFilterFields = "Sell-to Customer No.","No.","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code";
            RequestFilterHeading = 'Sales Invoice';
            column(ReportForNavId_5581; 5581)
            {
            }
            column(UPSshipperNumber;UPSshipperNumber)
            {
            }
            column(CompanyAddress_1_;CompanyAddress[1])
            {
            }
            column(CompanyAddress_2_;CompanyAddress[2])
            {
            }
            column(CompanyAddress_3_;CompanyAddress[3])
            {
            }
            column(CompanyAddress_4_;CompanyAddress[4])
            {
            }
            column(CompanyAddress_5_;CompanyAddress[5])
            {
            }
            column(CompanyAddress_6_;CompanyAddress[6])
            {
            }
            column(Sales_Invoice_Header__Amount_Including_VAT_;"Amount Including VAT")
            {
            }
            column(Sales_Invoice_Header__Amount_Including_VAT__Control9;"Amount Including VAT")
            {
            }
            column(AlternateControlNum;AlternateControlNum)
            {
            }
            column(AlternateControlNum_Control11;AlternateControlNum)
            {
            }
            column(Instructions;Instructions)
            {
            }
            column(WORKDATE;WorkDate)
            {
            }
            column(WORKDATE_Control14;WorkDate)
            {
            }
            column(ShipToAddress_1_;ShipToAddress[1])
            {
            }
            column(ShipToAddress_2_;ShipToAddress[2])
            {
            }
            column(ShipToAddress_3_;ShipToAddress[3])
            {
            }
            column(ShipToAddress_4_;ShipToAddress[4])
            {
            }
            column(ShipToAddress_5_;ShipToAddress[5])
            {
            }
            column(ShipToAddress_6_;ShipToAddress[6])
            {
            }
            column(ShipToAddress_7_;ShipToAddress[7])
            {
            }
            column(Sales_Invoice_Header_No_;"No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                FormatAddress.SalesInvShipTo(ShipToAddress,ShipToAddress,"Sales Invoice Header");

                CalcFields("Amount Including VAT");
                if UseAlternateCtrlNum then
                  AlternateControlNum := "Order No.";
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(UPSshipperNumber;UPSshipperNumber)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Enter UPS Shipper No.';
                        ToolTip = 'Specifies the United Parcel Service (UPS) shipping ID for the company. This ID is used to calculate shipping rates and create shipment documents and labels.';
                    }
                    field(UseAlternateCtrlNum;UseAlternateCtrlNum)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Use Alternate Control No.';
                        ToolTip = 'Specifies if you want to use an alternate control number.';
                    }
                    field(Instructions;Instructions)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Enter Instructions';
                        ToolTip = 'Specifies special instructions that you want to print on the COD tag. If you leave this field blank, no special instructions will be printed.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        FormatCompanyAddress;
    end;

    var
        CompanyInformation: Record "Company Information";
        ShipToAddress: array [8] of Text[30];
        CompanyAddress: array [6] of Text[50];
        Instructions: Text[30];
        UPSshipperNumber: Code[20];
        AlternateControlNum: Code[10];
        UseAlternateCtrlNum: Boolean;
        FormatAddress: Codeunit "Format Address";


    procedure FormatCompanyAddress()
    begin
        with CompanyInformation do begin
          Clear(CompanyAddress);
          CompanyAddress[1] := Name;
          CompanyAddress[2] := "Name 2";
          CompanyAddress[3] := Address;
          CompanyAddress[4] := "Address 2";
          if StrLen(City + ', ' + County + '  ' + "Post Code") > MaxStrLen(CompanyAddress[5]) then begin
            CompanyAddress[5] := City;
            CompanyAddress[6] := County + '  ' + "Post Code";
          end else
            if (City <> '') and (County <> '') then
              CompanyAddress[5] := City + ', ' + County + '  ' + "Post Code"
            else
              CompanyAddress[5] := DelChr(City + ' ' + County + ' ' + "Post Code",'<>');
          CompressArray(CompanyAddress);
        end;
    end;
}

