#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51813 "CAT-Cafe Revenue Reports"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CAT-Cafe Revenue Reports.rdlc';

    dataset
    {
        dataitem(UnknownTable61777;UnknownTable61777)
        {
            RequestFilterFields = Counts,"Posting Date";
            column(ReportForNavId_1; 1)
            {
            }
            column(pic;info.Picture)
            {
            }
            column(address;Address)
            {
            }
            column(tel;Tel)
            {
            }
            column(fax;Fax)
            {
            }
            column(pin;PIN)
            {
            }
            column(email;Email)
            {
            }
            column(vat;VAT)
            {
            }
            column(dates;Format(Today,0,4))
            {
            }
            column(datefilter;datefilter)
            {
            }
            column(PostingDate;"CAT-Cafe` Revenue Collections"."Posting Date")
            {
            }
            column(PostedBy;"CAT-Cafe` Revenue Collections"."Posted By")
            {
            }
            column(CafeCash;"CAT-Cafe` Revenue Collections"."CAFE CASH")
            {
            }
            column(CafeCredit;"CAT-Cafe` Revenue Collections"."CAFE CREDIT")
            {
            }
            column(CafeAdv;"CAT-Cafe` Revenue Collections"."CAFE ADVANCE")
            {
            }
            column(CafeTot;"CAT-Cafe` Revenue Collections"."CAFE TOTAL")
            {
            }
            column(ManCash;"CAT-Cafe` Revenue Collections"."MAN CASH")
            {
            }
            column(ManCred;"CAT-Cafe` Revenue Collections"."MAN CREDIT")
            {
            }
            column(ManAdv;"CAT-Cafe` Revenue Collections"."MAN ADVANCE")
            {
            }
            column(ManTotal;"CAT-Cafe` Revenue Collections"."MAN TOTAL")
            {
            }
            column(GTotal;"CAT-Cafe` Revenue Collections"."GRAND TOTAL")
            {
            }

            trigger OnPreDataItem()
            begin
                    if datefilter=0D then datefilter:=Today;

                      info.Reset;
                  if info.Find('-') then
                    info.CalcFields(Picture);

                Address:=info.Address+', '+info."Address 2"+', '+info.City;
                Tel:='TEL:'+info."Phone No.";
                Email:='EMAIL:'+info."E-Mail";

                //PIN:='PIN NO.: ';
                VAT:='VAT: '+info."VAT Registration No.";

                "CAT-Cafe` Revenue Collections".SetFilter("CAT-Cafe` Revenue Collections"."Posting Date",'=%1',datefilter);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        datefilter:=Today;
    end;

    var
        info: Record "Company Information";
        Address: Text[250];
        Tel: Code[100];
        Fax: Code[20];
        PIN: Code[20];
        Email: Text[50];
        VAT: Code[20];
        datefilter: Date;
}

