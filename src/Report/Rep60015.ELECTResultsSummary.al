#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 60015 "ELECT-Results Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ELECT-Results Summary.rdlc';

    dataset
    {
        dataitem(ElectPositions;UnknownTable60001)
        {
            DataItemTableView = sorting("Election Code","Position Code","Position Category","Electral District","School Code","Department Code","Campus Code") order(ascending);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Election Code";
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
            column(ElectralCode;ElectPositions."Election Code")
            {
            }
            column(ElectralDistrict;ElectPositions."Electral District")
            {
            }
            column(ElectPositionCategory;ElectPositions."Position Category")
            {
            }
            column(ElectPositionCode;ElectPositions."Position Code")
            {
            }
            column(ElectSchool;Schls)
            {
            }
            column(ElectDepartment;Deps)
            {
            }
            column(ElectCampus;Camps)
            {
            }
            column(WinnerNames;WinnerNames)
            {
            }
            column(WinnerVotes;WinnerVotes)
            {
            }
            column(WinnerPercentage;WinnerPercentage)
            {
            }
            column(WinnerPosition;WinnerPosition)
            {
            }
            column("Order";ELECTPositionCategories.Order)
            {
            }
            dataitem(ElectCandidates;UnknownTable60006)
            {
                DataItemLink = "Position Code"=field("Position Code"),"Position Category"=field("Position Category"),"Election Code"=field("Election Code");
                DataItemTableView = sorting("Election Code","Candidate No.") order(ascending);
                PrintOnlyIfDetail = true;
                column(ReportForNavId_1000000013; 1000000013)
                {
                }
                column(CandidateNo;ElectCandidates."Candidate No.")
                {
                }
                column(CandidateNames;ElectCandidates."Candidate Names")
                {
                }
                column(CandPic;ElectCandidates."Photo/Potrait")
                {
                }
                dataitem(ElectResRankings;UnknownTable60010)
                {
                    DataItemLink = "Election Code"=field("Election Code"),"Position Code"=field("Position Code"),"Candidate No."=field("Candidate No.");
                    column(ReportForNavId_1000000018; 1000000018)
                    {
                    }
                    column(Votesotten;ElectResRankings."Votes Count")
                    {
                    }
                    column(Ranking;ElectResRankings.Ranking)
                    {
                    }
                    column(CandIsWinner;ElectResRankings.Winner)
                    {
                    }
                    column(PercentageVotes;ElectResRankings."% Votes")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(seq);
                    ElectCandidates.CalcFields("Photo/Potrait");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ELECTPositionCategories.Reset;
                ELECTPositionCategories.SetRange("Election Code",ElectPositions."Election Code");
                ELECTPositionCategories.SetRange("Category Code",ElectPositions."Position Category");
                if ELECTPositionCategories.Find('-') then begin
                  end;

                Clear(WinnerNames);
                Clear(WinnerPercentage);
                Clear(WinnerPosition);
                Clear(WinnerVotes);
                ElectResRankings2.Reset;
                ElectResRankings2.SetRange("Election Code",ElectPositions."Election Code");
                ElectResRankings2.SetRange("Position Code",ElectPositions."Position Code");
                ElectResRankings2.SetRange(Winner,true);
                if ElectResRankings2.Find('-') then begin
                  ELECTCandidates2.Reset;
                  ELECTCandidates2.SetRange("Election Code",ElectPositions."Election Code");
                  ELECTCandidates2.SetRange("Candidate No.",ElectResRankings2."Candidate No.");
                  ELECTCandidates2.SetRange("Position Code",ElectPositions."Position Code");
                  if ELECTCandidates2.Find('-') then begin
                    ELECTCandidates2.CalcFields("Candidate Names");
                  WinnerNames:=ELECTCandidates2."Candidate Names";
                WinnerPercentage:=ElectResRankings2."% Votes";
                WinnerPosition:=ElectResRankings2."Position Code";
                WinnerVotes:=ElectResRankings2."Votes Count";
                end;
                  end;
                Clear(Schls);
                Clear(Deps);
                Clear(Camps);
                ELECTElectionsHeader.Reset;
                ELECTElectionsHeader.SetRange("Election Code",ElectPositions."Election Code");
                if ELECTElectionsHeader.Find('-') then begin
                  end;


                if ElectPositions."Election Code"='' then ElectPositions."Election Code":='- - -';
                if ElectPositions."Electral District"='' then ElectPositions."Electral District":='- - -';
                if ElectPositions."Position Category"='' then ElectPositions."Position Category":='- - -';
                if ElectPositions."School Code"='' then ElectPositions."School Code":='- - -';
                if ElectPositions."Department Code"='' then ElectPositions."Department Code":='- - -';
                if ElectPositions."Campus Code"='' then ElectPositions."Campus Code":='- - -';

                DimensionValue.Reset;
                DimensionValue.SetRange(Code,ElectPositions."School Code");
                if DimensionValue.Find('-') then Schls:=DimensionValue.Name
                else Schls:= ElectPositions."School Code";


                DimensionValue.Reset;
                DimensionValue.SetRange(Code,ElectPositions."Department Code");
                if DimensionValue.Find('-') then Deps:=DimensionValue.Name
                else Deps:=ElectPositions."Department Code";


                DimensionValue.Reset;
                DimensionValue.SetRange(Code,ElectPositions."Campus Code");
                if DimensionValue.Find('-') then Camps:=DimensionValue.Name
                else Camps:=ElectPositions."Campus Code";
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
        DimensionValue: Record "Dimension Value";
        Schls: Text[200];
        Deps: Text[200];
        Camps: Text[200];
        WinnerNames: Code[200];
        WinnerVotes: Integer;
        WinnerPercentage: Decimal;
        WinnerPosition: Code[20];
        ElectResRankings2: Record UnknownRecord60010;
        ELECTCandidates2: Record UnknownRecord60006;
        ELECTPositionCategories: Record UnknownRecord60003;
}

