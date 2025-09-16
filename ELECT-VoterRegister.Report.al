#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 60009 "ELECT-Voter Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ELECT-Voter Register.rdlc';

    dataset
    {
        dataitem(ElectPollingCenters;UnknownTable60008)
        {
            DataItemTableView = sorting("Election Code","Polling Center Code") order(ascending);
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
            column(ElectralCode;ElectPollingCenters."Election Code")
            {
            }
            column(ElectralDistrict;ElectPollingCenters."Electral District")
            {
            }
            column(ElectPollingCenter;ElectPollingCenters."Polling Center Code")
            {
            }
            column(ElectPositionCode;'')
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
            dataitem(ElectVoterRegister;UnknownTable60002)
            {
                DataItemLink = "Election Code"=field("Election Code"),"Electral District"=field("Electral District"),"Polling Center Code"=field("Polling Center Code");
                DataItemTableView = sorting("Election Code","Voter No.") order(ascending);
                column(ReportForNavId_1000000013; 1000000013)
                {
                }
                column(VoterNo;ElectVoterRegister."Voter No.")
                {
                }
                column(VoterNames;ElectVoterRegister."Voter Names")
                {
                }
                column(ELigibleVoter;ElectVoterRegister.Eligible)
                {
                }
                column(ELigibleTOVie;ElectVoterRegister."Manual Eligibility to Contest")
                {
                }
                column(seq;seq)
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
                Clear(Schls);
                Clear(Deps);
                Clear(Camps);
                ELECTElectionsHeader.Reset;
                ELECTElectionsHeader.SetRange("Election Code",ElectPollingCenters."Election Code");
                if ELECTElectionsHeader.Find('-') then begin
                  end;


                // // IF ElectPositions."Election Code"='' THEN ElectPositions."Election Code":='- - -';
                // // IF ElectPositions."Electral District"='' THEN ElectPositions."Electral District":='- - -';
                // // IF ElectPositions."Position Category"='' THEN ElectPositions."Position Category":='- - -';
                // // IF ElectPositions."School Code"='' THEN ElectPositions."School Code":='- - -';
                // // IF ElectPositions."Department Code"='' THEN ElectPositions."Department Code":='- - -';
                // // IF ElectPositions."Campus Code"='' THEN ElectPositions."Campus Code":='- - -';
                // //
                // // DimensionValue.RESET;
                // // DimensionValue.SETRANGE(Code,ElectPositions."School Code");
                // // IF DimensionValue.FIND('-') THEN Schls:=DimensionValue.Name
                // // ELSE Schls:= ElectPositions."School Code";
                // //
                // //
                // // DimensionValue.RESET;
                // // DimensionValue.SETRANGE(Code,ElectPositions."Department Code");
                // // IF DimensionValue.FIND('-') THEN Deps:=DimensionValue.Name
                // // ELSE Deps:=ElectPositions."Department Code";
                // //
                // //
                // // DimensionValue.RESET;
                // // DimensionValue.SETRANGE(Code,ElectPositions."Campus Code");
                // // IF DimensionValue.FIND('-') THEN Camps:=DimensionValue.Name
                // // ELSE Camps:=ElectPositions."Campus Code";
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

