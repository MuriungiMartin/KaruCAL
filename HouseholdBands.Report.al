#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78096 "Household Bands"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Household Bands.rdlc';
    EnableHyperlinks = true;

    dataset
    {
        dataitem(FundingBands;"Funding Band Entries")
        {
            RequestFilterFields = "Student No.";
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(StudNo;FundingBands."Student No.")
            {
            }
            column(BandCode;FundingBands."Band Code")
            {
            }
            column(BandDescription;FundingBands."Band Description")
            {
            }
            column(s;FundingBands."HouseHold Fee")
            {
            }
            column(StudentName;FundingBands."Student Name")
            {
            }
            column(Semester;FundingBands.Semester)
            {
            }
            column(CompName;CompName)
            {
            }
            column(RepDate;ReportDate)
            {
            }
            column(FNames;FullNames)
            {
            }
            column(ProgName;ProgName)
            {
            }
            column(DateStr;DateStr)
            {
            }
            column(Faculty;FacultyName)
            {
            }
            column(RoomNo;RoomNo)
            {
            }
            column(HostelName;HostelName)
            {
            }
            column(pobox;POBOX)
            {
            }

            trigger OnAfterGetRecord()
            var
                TTTT: Text[30];
            begin
                SEM1Fee:=0;
                SEM2Fee:=0;
                DateStr:='3rd October, 2024';
                Perc:=0;
                POBOX:='';
                FullNames:='';
                SEM1Fee:=FundingBands."HouseHold Fee"/2;
                SEM2Fee:=FundingBands."HouseHold Fee"/2;
                Cust.Reset;
                Cust.SetRange("No.",FundingBands."Student No.");
                if Cust.FindFirst then begin
                  FullNames:=Cust.Name;
                  FullNames:=ConvertStr(FullNames,' ',',');
                  FullNames:=SelectStr(1,FullNames);
                  POBOX:=Cust."Post Code" + ' '+ Cust.City;
                  end;
                  if (SEM1Fee=0) or (SEM2Fee=0) then begin
                    Band.Reset;
                    Band.SetRange("Band Code",FundingBands."Band Code");
                    if Band.FindFirst then begin
                      Perc:=Band."Household Percentage";
                      SEM1Fee:= ((Perc/100) *(FundingBands."Programme Cost"/2));
                      SEM2Fee:=((Perc/100) *(FundingBands."Programme Cost"/2));
                      end;
                    end;
                sems.Reset;
                sems.SetCurrentkey(Code);
                sems.SetFilter("HEF Processing Fee",'>%1',0);
                if sems.FindLast then begin
                  SEM1Fee+=sems."HEF Processing Fee";
                  SEM2Fee+=sems."HEF Processing Fee";
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

    var
        CompName: Code[100];
        ReportDate: Text;
        FullNames: Text[100];
        ProgName: Code[100];
        Prog: Record UnknownRecord61511;
        IntakeRec: Record UnknownRecord61383;
        ComenceDate: Date;
        DateStr: Text[50];
        FacultyName: Text[100];
        FacRec: Record "Dimension Value";
        StudHostel: Record "ACA-Students Hostel Rooms";
        RoomNo: Code[20];
        HostelRec: Record "ACA-Hostel Card";
        HostelName: Text[50];
        SEM1Fee: Decimal;
        SEM2Fee: Decimal;
        Cust: Record Customer;
        pobox: Text;
        Band: Record "Funding Band Categories";
        Perc: Decimal;
        sems: Record UnknownRecord61692;
}

