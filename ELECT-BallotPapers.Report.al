#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 60014 "ELECT-Ballot Papers"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ELECT-Ballot Papers.rdlc';

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
            dataitem(ElectCandidates;UnknownTable60006)
            {
                DataItemLink = "Position Code"=field("Position Code"),"Position Category"=field("Position Category"),"Election Code"=field("Election Code");
                DataItemTableView = sorting("Election Code","Candidate No.") order(ascending);
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

                trigger OnAfterGetRecord()
                begin
                    Clear(seq);
                    ElectCandidates.CalcFields("Photo/Potrait");
                end;
            }

            trigger OnAfterGetRecord()
            begin

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
}

