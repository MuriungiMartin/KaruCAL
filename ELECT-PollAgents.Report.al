#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 60013 "ELECT-Poll Agents"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ELECT-Poll Agents.rdlc';

    dataset
    {
        dataitem(ElectDist;UnknownTable60004)
        {
            DataItemTableView = sorting("Election Code","Electral District Doce");
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000012; 1000000012)
            {
            }
            column(ElectHeader;ELECTElectionsHeader."Election Description")
            {
            }
            column(CompNames;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address+' '+CompanyInformation."Address 2"+' '+CompanyInformation.City)
            {
            }
            column(COmpPhone;CompanyInformation."Phone No."+' '+CompanyInformation."Phone No. 2")
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }
            column(CompMail;CompanyInformation."Home Page"+', '+CompanyInformation."E-Mail")
            {
            }
            column(ElectralCode;ElectDist."Election Code")
            {
            }
            column(RetElectralDistrict;ElectDist."Electral District Doce")
            {
            }
            dataitem(ElectPollCent;UnknownTable60008)
            {
                DataItemLink = "Election Code"=field("Election Code"),"Electral District"=field("Electral District Doce");
                DataItemTableView = sorting("Election Code","Polling Center Code") order(ascending);
                PrintOnlyIfDetail = true;
                column(ReportForNavId_1000000013; 1000000013)
                {
                }
                column(RetPollingCent;ElctRet."Polling Center")
                {
                }
                column(RetOfficerId;ElectPollCent."Returning Officer ID")
                {
                }
                column(RetOfficerName;ElectPollCent."Returning Officer Name")
                {
                }
                dataitem(ElctRet;UnknownTable60014)
                {
                    DataItemLink = "Election Code"=field("Election Code"),"Electral District"=field("Electral District"),"Polling Center"=field("Polling Center Code");
                    DataItemTableView = where("Candidate No."=filter(<>""),"National ID"=filter(<>""));
                    RequestFilterFields = "Election Code","Electral District","Polling Center","Candidate No.";
                    column(ReportForNavId_1000000000; 1000000000)
                    {
                    }
                    column(seq;seq)
                    {
                    }
                    column(RetId;ElctRet."National ID")
                    {
                    }
                    column(RetNames;ElctRet.Names)
                    {
                    }
                    column(CandNo;ElctRet."Candidate No.")
                    {
                    }
                    column(CandName;ElctRet."Candidate Name")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        seq:=seq+1;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(seq);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ELECTElectionsHeader.Reset;
                ELECTElectionsHeader.SetRange("Election Code",ElctRet."Election Code");
                if ELECTElectionsHeader.Find('-') then begin
                  end;
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
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then begin
          CompanyInformation.CalcFields(Picture);
          end;
    end;

    var
        CompanyInformation: Record "Company Information";
        ELECTElectionsHeader: Record UnknownRecord60000;
        seq: Integer;
}

