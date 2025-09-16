#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51345 "Provisional Admission Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Provisional Admission Letter.rdlc';

    dataset
    {
        dataitem(UnknownTable61358;UnknownTable61358)
        {
            DataItemTableView = sorting("Application No.");
            RequestFilterFields = "Application No.";
            column(ReportForNavId_2953; 2953)
            {
            }
            column(UPPERCASE_COMPANYNAME_;UpperCase(COMPANYNAME))
            {
            }
            column(Application_Form_Header__Application_No__;"Application No.")
            {
            }
            column(FORMAT__Application_Date__0_4_;Format("Application Date",0,4))
            {
            }
            column(UPPERCASE_Surname_;UpperCase(Surname))
            {
            }
            column(UPPERCASE__Address_for_Correspondence1__;UpperCase("Address for Correspondence1"))
            {
            }
            column(UPPERCASE__Address_for_Correspondence2__;UpperCase("Address for Correspondence2"))
            {
            }
            column(UPPERCASE__Address_for_Correspondence3__;UpperCase("Address for Correspondence3"))
            {
            }
            column(UPPERCASE_Surname__________Other_Names__;UpperCase(Surname + ' ' + "Other Names"))
            {
            }
            column(Company_Address;Company.Address)
            {
            }
            column(Tel_________Company__Phone_No___________Company__Phone_No__2_;'Tel:' +' ' +Company."Phone No." + ',' + Company."Phone No. 2")
            {
            }
            column(Fax______Company__Fax_No__;'Fax: ' + Company."Fax No.")
            {
            }
            column(Your_application_for_admission_into_a_degree_programme_at_KARATINA_UNIVERSITY_during_;'Your application for admission into a degree programme at KARATINA UNIVERSITY during')
            {
            }
            column(AcademicYear;AcademicYear)
            {
            }
            column(academic_year_has_been_;' academic year has been')
            {
            }
            column(DataItem1102760015;'considered. You have, subsequently, been offered provisional admission into ' + FacultyName + ' for a course leading to the degree')
            {
            }
            column(This_interim_admission_is_subject_to_full_payment_of_;'This interim admission is subject to full payment of')
            {
            }
            column(AmountToPay;AmountToPay)
            {
            }
            column(on_or_before_;' on or before')
            {
            }
            column(FORMAT_DeadLineDate_0_4_;Format(DeadLineDate,0,4))
            {
            }
            column(Registration_will_end_as_;'Registration will end as')
            {
            }
            column(soon_as_the_capacity_in_this_programme_is_filled_up_;'soon as the capacity in this programme is filled up')
            {
            }
            column(The_capacity_for_this_degree_is_limited_and_registration_will_be_on_the_first_come_first_served_basis__;'The capacity for this degree is limited and registration will be on the first come first served basis.')
            {
            }
            column(DataItem1102760032;'Detailed fee structure is attached for your reference. Comprehensive joining instructions will be sent only to those who will have')
            {
            }
            column(met_the__;'met the ')
            {
            }
            column(AmountToPay_Control1102760034;AmountToPay)
            {
            }
            column(requirement_by__;' requirement by ')
            {
            }
            column(FORMAT_DeadLineDate_0_4__Control1102760036;Format(DeadLineDate,0,4))
            {
            }
            column(Make_your_payments_to_;'Make your payments to')
            {
            }
            column(Account_number_____________________;'Account number: ******************')
            {
            }
            column(of_Equity_Bank__TMUC_or_at_any_branch_of_Equity_;' of Equity Bank, KILIMAMBOGO or at any branch of Equity')
            {
            }
            column(Bank_countrywide__You_will_be_required_to_submit_banking_slip_s__indicating_the_amount_of_money_paid__Ensure_you_get_;'Bank countrywide. You will be required to submit banking slip(s) indicating the amount of money paid. Ensure you get')
            {
            }
            column(DataItem1102760041;'official University receipt for the amount paid from Finance Department. Cash, personal or institutional cheques are not acceptable')
            {
            }
            column(Thank_you__;'Thank you.')
            {
            }
            column(ProgName;ProgName)
            {
            }
            column(OFFICE_OF_THE_DEPUTY_REGISTRAR___ACADEMIC_AFFAIRSCaption;OFFICE_OF_THE_DEPUTY_REGISTRAR___ACADEMIC_AFFAIRSCaptionLbl)
            {
            }
            column(Our_Ref_Caption;Our_Ref_CaptionLbl)
            {
            }
            column(Your_Ref_Caption;Your_Ref_CaptionLbl)
            {
            }
            column(Dear_Ms__Mr_Caption;Dear_Ms__Mr_CaptionLbl)
            {
            }
            column(RE_Caption;RE_CaptionLbl)
            {
            }
            column(PROVISIONAL_ADMISSION_INTO_A_DEGREE_PROGRAMMECaption;PROVISIONAL_ADMISSION_INTO_A_DEGREE_PROGRAMMECaptionLbl)
            {
            }
            column(Date_Caption;Date_CaptionLbl)
            {
            }
            column(FOR__DEPUTY_REGISTRAR__ACADEMIC_AFFAIRSCaption;FOR__DEPUTY_REGISTRAR__ACADEMIC_AFFAIRSCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                AcademicYear:="ACA-Applic. Form Header"."Academic Year";
                AmountToPay:='';
                //DeadLineDate:=TODAY;
                Amount:=0;
                
                /*Get the deadline for the payment as the first day of the semester*/
                Semester.Reset;
                Semester.SetRange(Semester.Code,"ACA-Applic. Form Header"."Admitted Semester");
                if Semester.Find('-') then
                  begin
                    DeadLineDate:=Semester.From;
                  end;
                /*Get the amount to be paid by the student*/
                NewStudCharges.Reset;
                NewStudCharges.SetRange(NewStudCharges."Programme Code","ACA-Applic. Form Header"."Admitted Degree");
                if NewStudCharges.Find('-') then
                  begin
                    repeat
                      Amount:=Amount + NewStudCharges.Amount;
                    until NewStudCharges.Next=0;
                  end;
                
                //PKK
                StageCharges.Reset;
                StageCharges.SetRange(StageCharges."Programme Code","ACA-Applic. Form Header"."Admitted Degree");
                StageCharges.SetRange(StageCharges."Stage Code","ACA-Applic. Form Header"."Admitted To Stage");
                if StageCharges.Find('-') then begin
                repeat
                Amount:=Amount + StageCharges.Amount;
                until StageCharges.Next = 0;
                end;
                //PKK
                
                FeeByStage.Reset;
                FeeByStage.SetRange(FeeByStage."Programme Code","ACA-Applic. Form Header"."Admitted Degree");
                FeeByStage.SetRange(FeeByStage."Stage Code","ACA-Applic. Form Header"."Admitted To Stage");
                FeeByStage.SetRange(FeeByStage.Semester,"ACA-Applic. Form Header"."Admitted Semester");
                FeeByStage.SetRange(FeeByStage."Settlemet Type","ACA-Applic. Form Header"."Settlement Type");
                if FeeByStage.Find('-') then begin Amount:=Amount + FeeByStage."Break Down"; end;
                AmountToPay:='Kshs. ' + Format(Amount) + '/=';
                
                DimVal.Reset;
                DimVal.SetRange(DimVal."Dimension Code",'COURSE');
                DimVal.SetRange(DimVal.Code,"ACA-Applic. Form Header".School1);
                if DimVal.Find('-') then
                  begin
                    FacultyName:=DimVal.Name;
                  end;
                Prog.Reset;
                if Prog.Get("ACA-Applic. Form Header"."First Degree Choice") then
                 begin
                   ProgName:=Prog.Description;
                 end;

            end;

            trigger OnPreDataItem()
            begin
                /*
                GeneralSetUp.RESET;
                IF GeneralSetUp.FIND('-') THEN
                DeadLineDate:=GeneralSetUp."Applications Date Line";
                */

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
        Company: Record UnknownRecord61339;
        AcademicYear: Text[30];
        AmountToPay: Text[30];
        DeadLineDate: Date;
        NewStudCharges: Record UnknownRecord61543;
        Amount: Decimal;
        Semester: Record UnknownRecord61692;
        FeeByStage: Record UnknownRecord61523;
        FacultyName: Text[100];
        DimVal: Record "Dimension Value";
        Prog: Record UnknownRecord61511;
        ProgName: Text[100];
        StageCharges: Record UnknownRecord61533;
        GeneralSetUp: Record UnknownRecord61534;
        OFFICE_OF_THE_DEPUTY_REGISTRAR___ACADEMIC_AFFAIRSCaptionLbl: label 'OFFICE OF THE DEPUTY REGISTRAR - ACADEMIC AFFAIRS';
        Our_Ref_CaptionLbl: label 'Our Ref:';
        Your_Ref_CaptionLbl: label 'Your Ref:';
        Dear_Ms__Mr_CaptionLbl: label 'Dear Ms./Mr.';
        RE_CaptionLbl: label 'RE:';
        PROVISIONAL_ADMISSION_INTO_A_DEGREE_PROGRAMMECaptionLbl: label 'PROVISIONAL ADMISSION INTO A DEGREE PROGRAMME';
        Date_CaptionLbl: label 'Date:';
        FOR__DEPUTY_REGISTRAR__ACADEMIC_AFFAIRSCaptionLbl: label 'FOR: DEPUTY REGISTRAR, ACADEMIC AFFAIRS';
}

