#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51349 "Admission Fee Structure"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Admission Fee Structure.rdlc';

    dataset
    {
        dataitem(UnknownTable61372;UnknownTable61372)
        {
            DataItemTableView = sorting("Admission No.");
            RequestFilterFields = "Admission No.";
            column(ReportForNavId_3773; 3773)
            {
            }
            column(UPPERCASE_COMPANYNAME_;UpperCase(COMPANYNAME))
            {
            }
            column(CompanyInfo__Phone_No_____________CompanyInfo__Phone_No__2_;CompanyInfo."Phone No." + ' , ' + CompanyInfo."Phone No. 2")
            {
            }
            column(CompanyInfo_Address;CompanyInfo.Address)
            {
            }
            column(CompanyInfo__Fax_No__;CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfo__Address_2__;CompanyInfo."Address 2" )
            {
            }
            column(CompanyInfo_City;CompanyInfo.City)
            {
            }
            column(TAmount___TFee;TAmount + TFee)
            {
            }
            column(TFee;TFee)
            {
            }
            column(IntC__1;IntC +1)
            {
            }
            column(OFFICE_OF_THE__REGISTRAR___ACADEMIC_AFFAIRSCaption;OFFICE_OF_THE__REGISTRAR___ACADEMIC_AFFAIRSCaptionLbl)
            {
            }
            column(Tel_Caption;Tel_CaptionLbl)
            {
            }
            column(Fax_Caption;Fax_CaptionLbl)
            {
            }
            column(Our_Ref_Caption;Our_Ref_CaptionLbl)
            {
            }
            column(Your_Ref_Caption;Your_Ref_CaptionLbl)
            {
            }
            column(FINANCIAL_REQUIREMENTSCaption;FINANCIAL_REQUIREMENTSCaptionLbl)
            {
            }
            column(FEE_STRUCTURECaption;FEE_STRUCTURECaptionLbl)
            {
            }
            column(In_order_to_be_registered__a_student_is_expected_to_pay_the_following_fees_Caption;In_order_to_be_registered__a_student_is_expected_to_pay_the_following_fees_CaptionLbl)
            {
            }
            column(COMPULSORYCaption;COMPULSORYCaptionLbl)
            {
            }
            column(AMOUNT_KSHS_Caption;AMOUNT_KSHS_CaptionLbl)
            {
            }
            column(TOTALCaption;TOTALCaptionLbl)
            {
            }
            column(N_B_Caption;N_B_CaptionLbl)
            {
            }
            column(DataItem1102760023;The_above_indicated_financial_requirements_do_not_include_accomodation__food__books_and_stationery__and_personal_effects_a_stLbl)
            {
            }
            column(ACCOMMODATIONCaption;ACCOMMODATIONCaptionLbl)
            {
            }
            column(B_Caption;B_CaptionLbl)
            {
            }
            column(DataItem1102760026;The_University_is_not_obliged_to_offer_accommodation_services_to_students__However__there_are_limited_number__of_rooms_availaLbl)
            {
            }
            column(Tuition_FeesCaption;Tuition_FeesCaptionLbl)
            {
            }
            column(Admission_Form_Header_Admission_No_;"Admission No.")
            {
            }
            column(Admission_Form_Header_Degree_Admitted_To;"Degree Admitted To")
            {
            }
            dataitem(UnknownTable61543;UnknownTable61543)
            {
                DataItemLink = "Programme Code"=field("Degree Admitted To");
                column(ReportForNavId_2355; 2355)
                {
                }
                column(New_Student_Charges_Amount;Amount)
                {
                }
                column(New_Student_Charges_Description;Description)
                {
                }
                column(IntC;IntC)
                {
                }
                column(New_Student_Charges_Programme_Code;"Programme Code")
                {
                }
                column(New_Student_Charges_Code;Code)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TAmount:=TAmount + "ACA-New Student Charges".Amount;
                    IntC:=IntC +1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TAmount:=0;
                IntC:=0;
                TFee:=0;
                FeeByStage.Reset;
                FeeByStage.SetRange(FeeByStage."Programme Code","ACA-Adm. Form Header"."Degree Admitted To");
                FeeByStage.SetRange(FeeByStage."Stage Code","ACA-Adm. Form Header"."Stage Admitted To");
                FeeByStage.SetRange(FeeByStage.Semester,"ACA-Adm. Form Header"."Semester Admitted To");
                FeeByStage.SetRange(FeeByStage."Settlemet Type","ACA-Adm. Form Header"."Settlement Type");
                if FeeByStage.Find('-') then begin TFee:=FeeByStage."Break Down"; end;
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

    trigger OnPreReport()
    begin
        CompanyInfo.Reset();
        CompanyInfo.Get();
    end;

    var
        CompanyInfo: Record "Company Information";
        TAmount: Decimal;
        IntC: Integer;
        TFee: Decimal;
        FeeByStage: Record UnknownRecord61523;
        OFFICE_OF_THE__REGISTRAR___ACADEMIC_AFFAIRSCaptionLbl: label 'OFFICE OF THE  REGISTRAR - ACADEMIC AFFAIRS';
        Tel_CaptionLbl: label 'Tel:';
        Fax_CaptionLbl: label 'Fax:';
        Our_Ref_CaptionLbl: label 'Our Ref:';
        Your_Ref_CaptionLbl: label 'Your Ref:';
        FINANCIAL_REQUIREMENTSCaptionLbl: label 'FINANCIAL REQUIREMENTS';
        FEE_STRUCTURECaptionLbl: label 'FEE STRUCTURE';
        In_order_to_be_registered__a_student_is_expected_to_pay_the_following_fees_CaptionLbl: label 'In order to be registered, a student is expected to pay the following fees.';
        COMPULSORYCaptionLbl: label 'COMPULSORY';
        AMOUNT_KSHS_CaptionLbl: label 'AMOUNT KSHS.';
        TOTALCaptionLbl: label 'TOTAL';
        N_B_CaptionLbl: label 'N.B.';
        The_above_indicated_financial_requirements_do_not_include_accomodation__food__books_and_stationery__and_personal_effects_a_stLbl: label 'The above indicated financial requirements do not include accomodation, food, books and stationery, and personal effects a student may require.';
        ACCOMMODATIONCaptionLbl: label 'ACCOMMODATION';
        B_CaptionLbl: label 'B.';
        The_University_is_not_obliged_to_offer_accommodation_services_to_students__However__there_are_limited_number__of_rooms_availaLbl: label 'The University is not obliged to offer accommodation services to students. However, there are limited number  of rooms available for rental, which will be allocated on a competitive basis. The available rooms arecurrently rented out to stuents at Kshs. 3,000/= per semester.';
        Tuition_FeesCaptionLbl: label 'Tuition Fees';
}

