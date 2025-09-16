#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51800 "ACA-Consolidated Gradesheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Consolidated Gradesheet.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type","Entry No.") order(ascending);
            RequestFilterFields = "Programme Filter",Stage,"Stage Filter","Options Filter","Cummulative Year Filter","Student No.",Semester;
            column(ReportForNavId_2901; 2901)
            {
            }
            column(COMPANYNAME;'KARATINA UNIVERSITY')
            {
            }
            column(Constituent;'(The University)')
            {
            }
            column(SDesc;SDesc)
            {
            }
            column(FDesc;FDesc)
            {
            }
            column(Dept;Dept)
            {
            }
            column(PName;PName)
            {
            }
            column(SemPoints;"ACA-Course Registration"."Semester Points")
            {
            }
            column(SemHrs;"ACA-Course Registration"."Semester Hours")
            {
            }
            column(Comb;Comb)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Course_Registration_Session;Session)
            {
            }
            column(sName;sName)
            {
            }
            column(acadyear;acadyear)
            {
            }
            column(Semesters;Sems)
            {
            }
            column(ProgrammeCode;"ACA-Course Registration".Programme)
            {
            }
            column(studName;"ACA-Course Registration"."Student Name")
            {
            }
            column(ColumnH_1_;ColumnH[1])
            {
            }
            column(ColumnH_8_;ColumnH[8])
            {
            }
            column(ColumnH_6_;ColumnH[6])
            {
            }
            column(ColumnH_7_;ColumnH[7])
            {
            }
            column(ColumnH_4_;ColumnH[4])
            {
            }
            column(ColumnH_3_;ColumnH[3])
            {
            }
            column(ColumnH_5_;ColumnH[5])
            {
            }
            column(ColumnH_2_;ColumnH[2])
            {
            }
            column(ColumnH_15_;ColumnH[15])
            {
            }
            column(ColumnH_14_;ColumnH[14])
            {
            }
            column(ColumnH_13_;ColumnH[13])
            {
            }
            column(ColumnH_12_;ColumnH[12])
            {
            }
            column(ColumnH_10_;ColumnH[10])
            {
            }
            column(ColumnH_9_;ColumnH[9])
            {
            }
            column(ColumnH_11_;ColumnH[11])
            {
            }
            column(ColumnH_23_;ColumnH[23])
            {
            }
            column(ColumnH_22_;ColumnH[22])
            {
            }
            column(ColumnH_21_;ColumnH[21])
            {
            }
            column(ColumnH_20_;ColumnH[20])
            {
            }
            column(ColumnH_19_;ColumnH[19])
            {
            }
            column(ColumnH_18_;ColumnH[18])
            {
            }
            column(ColumnH_17_;ColumnH[17])
            {
            }
            column(ColumnH_16_;ColumnH[16])
            {
            }
            column(uColumnV_1_;uColumnV[1])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_2_;uColumnV[2])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_3_;uColumnV[3])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_4_;uColumnV[4])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_5_;uColumnV[5])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_6_;uColumnV[6])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_7_;uColumnV[7])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_8_;uColumnV[8])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_9_;uColumnV[9])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_10_;uColumnV[10])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_11_;uColumnV[11])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_12_;uColumnV[12])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_13_;uColumnV[13])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_14_;uColumnV[14])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_15_;uColumnV[15])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_16_;uColumnV[16])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_17_;uColumnV[17])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_18_;uColumnV[18])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_19_;uColumnV[19])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_20_;uColumnV[20])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_21_;uColumnV[21])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_22_;uColumnV[22])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_23_;uColumnV[23])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_30_;uColumnV[30])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_29_;uColumnV[29])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_28_;uColumnV[28])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_26_;ColumnH[26])
            {
            }
            column(ColumnH_30_;ColumnH[30])
            {
            }
            column(ColumnH_29_;ColumnH[29])
            {
            }
            column(ColumnH_28_;ColumnH[28])
            {
            }
            column(uColumnV_27_;uColumnV[27])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_27_;ColumnH[27])
            {
            }
            column(uColumnV_26_;uColumnV[26])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_25_;ColumnH[25])
            {
            }
            column(uColumnV_25_;uColumnV[25])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_24_;ColumnH[24])
            {
            }
            column(uColumnV_24_;uColumnV[24])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_1_;sColumnV[1])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_2_;sColumnV[2])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_3_;sColumnV[3])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_4_;sColumnV[4])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_5_;sColumnV[5])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_6_;sColumnV[6])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_7_;sColumnV[7])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_8_;sColumnV[8])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_9_;sColumnV[9])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_10_;sColumnV[10])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_11_;sColumnV[11])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_12_;sColumnV[12])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_13_;sColumnV[13])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_14_;sColumnV[14])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_15_;sColumnV[15])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_16_;sColumnV[16])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_17_;sColumnV[17])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_18_;sColumnV[18])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_19_;sColumnV[19])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_20_;sColumnV[20])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_21_;sColumnV[21])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_22_;sColumnV[22])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_23_;sColumnV[23])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_24_;sColumnV[24])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_25_;sColumnV[25])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_26_;sColumnV[26])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_27_;sColumnV[27])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_28_;sColumnV[28])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_29_;sColumnV[29])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_30_;sColumnV[30])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_35_;sColumnV[35])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_34_;sColumnV[34])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_33_;sColumnV[33])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_32_;sColumnV[32])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_31_;sColumnV[31])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_31_;ColumnH[31])
            {
            }
            column(ColumnH_35_;ColumnH[35])
            {
            }
            column(ColumnH_34_;ColumnH[34])
            {
            }
            column(ColumnH_33_;ColumnH[33])
            {
            }
            column(ColumnH_32_;ColumnH[32])
            {
            }
            column(uColumnV_35_;uColumnV[35])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_34_;uColumnV[34])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_33_;uColumnV[33])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_32_;uColumnV[32])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_31_;uColumnV[31])
            {
                DecimalPlaces = 0:0;
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(ColumnV_1_;ColumnV[1])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_8_;ColumnV[8])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_7_;ColumnV[7])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_6_;ColumnV[6])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_5_;ColumnV[5])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_4_;ColumnV[4])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_3_;ColumnV[3])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_2_;ColumnV[2])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_14_;ColumnV[14])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_13_;ColumnV[13])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_12_;ColumnV[12])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_11_;ColumnV[11])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_10_;ColumnV[10])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_9_;ColumnV[9])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_23_;ColumnV[23])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_22_;ColumnV[22])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_21_;ColumnV[21])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_20_;ColumnV[20])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_19_;ColumnV[19])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_18_;ColumnV[18])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_17_;ColumnV[17])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_16_;ColumnV[16])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_15_;ColumnV[15])
            {
                DecimalPlaces = 0:0;
            }
            column(SCount;SCount)
            {
            }
            column(ColumnV_30_;ColumnV[30])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_29_;ColumnV[29])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_28_;ColumnV[28])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_27_;ColumnV[27])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_26_;ColumnV[26])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_25_;ColumnV[25])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_24_;ColumnV[24])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_35_;ColumnV[35])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_34_;ColumnV[34])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_33_;ColumnV[33])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_32_;ColumnV[32])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_31_;ColumnV[31])
            {
                DecimalPlaces = 0:0;
            }
            column(Consolidated_MarksheetCaption;'CONSOLIDATED MARKSHEET')
            {
            }
            column(Year_of_Study_Caption;'YEAR OF STUDY')
            {
            }
            column(Faculty_Caption;'FACULTY')
            {
            }
            column(Department_Caption;'DEPARTMENT')
            {
            }
            column(Programme_of_Study_Caption;'PROGRAMME')
            {
            }
            column(CurrReport_PAGENOCaption;'PAGE')
            {
            }
            column(Intake_Caption;'INTAKE')
            {
            }
            column(Registration_No_Caption;'REG. NO.')
            {
            }
            column(NamesCaption;'NAME')
            {
            }
            column(UNITS__Caption;'UNITS==>')
            {
            }
            column(Serial_No_Caption;'SERIAL')
            {
            }
            column(Guide_on_remarks_Caption;'Guide on Remarks')
            {
            }
            column(DataItem1102760088;text101)
            {
            }
            column(DataItem1102760089;text102)
            {
            }
            column(DataItem1102760090;text103)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }
            column(TColumnV_1_;TColumnV[1])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_2_;TColumnV[2])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_3_;TColumnV[3])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_4_;TColumnV[4])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_5_;TColumnV[5])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_6_;TColumnV[6])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_7_;TColumnV[7])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_8_;TColumnV[8])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_9_;TColumnV[9])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_10_;TColumnV[10])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_11_;TColumnV[11])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_12_;TColumnV[12])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_13_;TColumnV[13])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_14_;TColumnV[14])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_15_;TColumnV[15])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_16_;TColumnV[16])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_17_;TColumnV[17])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_18_;TColumnV[18])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_19_;TColumnV[19])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_20_;TColumnV[20])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_1_2;Column_H[1])
            {
            }
            column(ColumnH_8_2;Column_H[8])
            {
            }
            column(ColumnH_6_2;Column_H[6])
            {
            }
            column(ColumnH_7_2;Column_H[7])
            {
            }
            column(ColumnH_4_2;Column_H[4])
            {
            }
            column(ColumnH_3_2;Column_H[3])
            {
            }
            column(ColumnH_5_2;Column_H[5])
            {
            }
            column(ColumnH_2_2;Column_H[2])
            {
            }
            column(ColumnH_15_2;Column_H[15])
            {
            }
            column(ColumnH_14_2;Column_H[14])
            {
            }
            column(ColumnH_13_2;Column_H[13])
            {
            }
            column(ColumnH_12_2;Column_H[12])
            {
            }
            column(ColumnH_10_2;Column_H[10])
            {
            }
            column(ColumnH_9_2;Column_H[9])
            {
            }
            column(ColumnH_11_2;Column_H[11])
            {
            }
            column(ColumnH_23_2;Column_H[23])
            {
            }
            column(ColumnH_22_2;Column_H[22])
            {
            }
            column(ColumnH_21_2;Column_H[21])
            {
            }
            column(ColumnH_20_2;Column_H[20])
            {
            }
            column(ColumnH_19_2;Column_H[19])
            {
            }
            column(ColumnH_18_2;Column_H[18])
            {
            }
            column(ColumnH_17_2;Column_H[17])
            {
            }
            column(ColumnH_16_2;Column_H[16])
            {
            }
            column(uColumnV_1_2;uColumn_V[1])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_2_2;uColumn_V[2])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_3_2;uColumn_V[3])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_4_2;uColumn_V[4])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_5_2;uColumn_V[5])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_6_2;uColumn_V[6])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_7_2;uColumn_V[7])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_8_2;uColumn_V[8])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_9_2;uColumn_V[9])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_10_2;uColumn_V[10])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_11_2;uColumn_V[11])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_12_2;uColumn_V[12])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_13_2;uColumn_V[13])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_14_2;uColumn_V[14])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_15_2;uColumn_V[15])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_16_2;uColumn_V[16])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_17_2;uColumn_V[17])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_18_2;uColumn_V[18])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_19_2;uColumn_V[19])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_20_2;uColumn_V[20])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_21_2;uColumn_V[21])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_22_2;uColumn_V[22])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_23_2;uColumn_V[23])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_30_2;uColumn_V[30])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_29_2;uColumn_V[29])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_28_2;uColumn_V[28])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_26_2;Column_H[26])
            {
            }
            column(ColumnH_30_2;Column_H[30])
            {
            }
            column(ColumnH_29_2;Column_H[29])
            {
            }
            column(ColumnH_28_2;Column_H[28])
            {
            }
            column(uColumnV_27_2;uColumn_V[27])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_27_2;Column_H[27])
            {
            }
            column(uColumnV_26_2;uColumn_V[26])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_25_2;Column_H[25])
            {
            }
            column(uColumnV_25_2;uColumn_V[25])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_24_2;Column_H[24])
            {
            }
            column(uColumnV_24_2;uColumn_V[24])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_1_2;sColumn_V[1])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_2_2;sColumn_V[2])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_3_2;sColumn_V[3])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_4_2;sColumn_V[4])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_5_2;sColumn_V[5])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_6_2;sColumn_V[6])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_7_2;sColumn_V[7])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_8_2;sColumn_V[8])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_9_2;sColumn_V[9])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_10_2;sColumn_V[10])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_11_2;sColumn_V[11])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_12_2;sColumn_V[12])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_13_2;sColumn_V[13])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_14_2;sColumn_V[14])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_15_2;sColumn_V[15])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_16_2;sColumn_V[16])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_17_2;sColumn_V[17])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_18_2;sColumn_V[18])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_19_2;sColumn_V[19])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_20_2;sColumn_V[20])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_21_2;sColumn_V[21])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_22_2;sColumn_V[22])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_23_2;sColumn_V[23])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_24_2;sColumn_V[24])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_25_2;sColumn_V[25])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_26_2;sColumn_V[26])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_27_2;sColumn_V[27])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_28_2;sColumn_V[28])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_29_2;sColumn_V[29])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_30_2;sColumn_V[30])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_35_2;sColumn_V[35])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_34_2;sColumn_V[34])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_33_2;sColumn_V[33])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_32_2;sColumn_V[32])
            {
                DecimalPlaces = 0:0;
            }
            column(sColumnV_31_2;sColumn_V[31])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnH_31_2;Column_H[31])
            {
            }
            column(ColumnH_35_2;Column_H[35])
            {
            }
            column(ColumnH_34_2;Column_H[34])
            {
            }
            column(ColumnH_33_2;Column_H[33])
            {
            }
            column(ColumnH_32_2;Column_H[32])
            {
            }
            column(uColumnV_35_2;uColumn_V[35])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_34_2;uColumn_V[34])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_33_2;uColumn_V[33])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_32_2;uColumn_V[32])
            {
                DecimalPlaces = 0:0;
            }
            column(uColumnV_31_2;uColumn_V[31])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_1_2;Column_V[1])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_8_2;Column_V[8])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_7_2;Column_V[7])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_6_2;Column_V[6])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_5_2;Column_V[5])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_4_2;Column_V[4])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_3_2;Column_V[3])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_2_2;Column_V[2])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_14_2;Column_V[14])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_13_2;Column_V[13])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_12_2;Column_V[12])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_11_2;Column_V[11])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_10_2;Column_V[10])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_9_2;Column_V[9])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_23_2;Column_V[23])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_22_2;Column_V[22])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_21_2;Column_V[21])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_20_2;Column_V[20])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_19_2;Column_V[19])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_18_2;Column_V[18])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_17_2;Column_V[17])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_16_2;Column_V[16])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_15_2;Column_V[15])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_30_2;Column_V[30])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_29_2;Column_V[29])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_28_2;Column_V[28])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_27_2;Column_V[27])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_26_2;Column_V[26])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_25_2;Column_V[25])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_24_2;Column_V[24])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_35_2;Column_V[35])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_34_2;Column_V[34])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_33_2;Column_V[33])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_32_2;Column_V[32])
            {
                DecimalPlaces = 0:0;
            }
            column(ColumnV_31_2;Column_V[31])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_1_2;TColumn_V[1])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_2_2;TColumn_V[2])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_3_2;TColumn_V[3])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_4_2;TColumn_V[4])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_5_2;TColumn_V[5])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_6_2;TColumn_V[6])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_7_2;TColumn_V[7])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_8_2;TColumn_V[8])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_9_2;TColumn_V[9])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_10_2;TColumn_V[10])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_11_2;TColumn_V[11])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_12_2;TColumn_V[12])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_13_2;TColumn_V[13])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_14_2;TColumn_V[14])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_15_2;TColumn_V[15])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_16_2;TColumn_V[16])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_17_2;TColumn_V[17])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_18_2;TColumn_V[18])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_19_2;TColumn_V[19])
            {
                DecimalPlaces = 0:0;
            }
            column(TColumnV_20_2;TColumn_V[20])
            {
                DecimalPlaces = 0:0;
            }

            trigger OnAfterGetRecord()
            begin
                   Clear(PastSemPoints);
                   Clear(PastSemHours);
                   Clear(CummGPA2);
                    SCount:=SCount+1;
                
                
                   Clear(semGPA2);
                
                if Prog.Get("ACA-Course Registration".Programme) then begin
                PName:=Prog.Description;
                if FacultyR.Get(Prog.Faculty) then
                FDesc:=FacultyR.Description;
                
                DValue.Reset;
                DValue.SetRange(DValue.Code,Prog.Department);
                if DValue.Find('-') then
                Dept:=DValue.Name;
                
                end;
                
                
                
                /*CALCFIELDS("Course Registration"."Semester Points","Course Registration"."Semester Hours",
                "Course Registration"."Cummulative Hours","Course Registration"."Cummulative Points",
                "Course Registration"."Average Semester GPA","Course Registration"."Average Cummulative GPA",
                "Course Registration"."Semester Points","Course Registration"."Semester Hours");*/
                // Pick the Units Header Here
                if not headerDone then begin
                Clear(ColumnH);
                Clear(TColumnV);
                Clear(uColumnV);
                Clear(i);
                CReg.Reset;
                CReg.SetRange(CReg.Programme,GetFilter("ACA-Course Registration"."Programme Filter"));
                CReg.SetRange(CReg.Semester,Sems);
                //CReg.SETRANGE(CReg."Academic Year",acadyear);
                if CReg.Find('-') then begin
                 repeat
                  begin
                   studentsUnits.Reset;
                   studentsUnits.SetRange(studentsUnits."Student No.",CReg."Student No.");
                   studentsUnits.SetRange(studentsUnits.Semester,Sems);
                  // studentsUnits.SETRANGE(studentsUnits."Academic Year",acadyear);
                   if studentsUnits.Find('-') then begin
                     repeat
                      begin
                         Clear(UnitHeaderSet);
                         counts:=0;
                        repeat
                        begin
                        counts:=counts+1;
                        if ColumnH[counts]=studentsUnits.Unit then UnitHeaderSet:=true;
                        end;
                        until counts=ArrayLen(ColumnH);
                        i:=i+1;
                        if UnitHeaderSet=false then begin
                          ColumnH[i]:=studentsUnits.Unit;
                          // Calculate the UnitMean and MeanGrade Here
                          Clear(totStudents);
                          Clear(totalMarks);
                          stdUnits.Reset;
                          stdUnits.SetRange(stdUnits.Unit,ColumnH[i]);
                          stdUnits.SetRange(stdUnits.Semester,Sems);
                         // stdUnits.SETRANGE(stdUnits."Academic Year",acadyear);
                          stdUnits.SetFilter(stdUnits.Grade,'%1..%2','A','F');
                          if stdUnits.Find('-') then begin
                          totStudents:=stdUnits.Count;
                          repeat
                            begin
                       ///////////////////////////      TColumnV[i]:=TColumnV[i]+stdUnits.Grade;
                             totalMarks:=totalMarks+stdUnits."Total Marks";
                            end;
                          until stdUnits.Next = 0;
                          end;
                          if totStudents>0 then begin
                          TColumnV[i]:=TColumnV[i]/totStudents;
                          totalMarks:=totalMarks/totStudents;
                          end;
                          TColumnV[i]:=ROUND(TColumnV[i],0.01,'=');
                          uColumnV[i]:=GetGrade(totalMarks,"ACA-Course Registration".Programme);
                        end;
                      end;
                     until studentsUnits.Next = 0;
                   end;
                  end;
                 until CReg.Next=0;
                end;
                end; // Not headerDone
                
                // Populate the Scores Here
                Clear(i);
                Clear(ColumnV);
                repeat
                  begin
                  i:=i+1;
                   studentsUnits.Reset;
                   studentsUnits.SetRange(studentsUnits."Student No.","Student No.");
                   studentsUnits.SetRange(studentsUnits.Semester,Sems);
                  // studentsUnits.SETRANGE(studentsUnits."Academic Year",acadyear);
                   studentsUnits.SetRange(studentsUnits.Unit,ColumnH[i]);
                   if studentsUnits.Find('-') then begin
                    ColumnV[i]:=studentsUnits.Grade;
                   end;
                  end;
                until ((ColumnH[i] = '') or (i=ArrayLen(ColumnH)));
                
                
                // Pick the Units Names Here
                if not headerDone_1 then begin
                Clear(Column_H);
                Clear(TColumn_V);
                Clear(uColumn_V);
                Clear(i);
                CReg.Reset;
                CReg.SetRange(CReg.Programme,GetFilter("ACA-Course Registration"."Programme Filter"));
                CReg.SetRange(CReg.Semester,Sems);
                //CReg.SETRANGE(CReg."Academic Year",acadyear);
                if CReg.Find('-') then begin
                 repeat
                  begin
                   studentsUnits.Reset;
                   studentsUnits.SetRange(studentsUnits."Student No.",CReg."Student No.");
                   studentsUnits.SetRange(studentsUnits.Semester,Sems);
                  // studentsUnits.SETRANGE(studentsUnits."Academic Year",acadyear);
                   if studentsUnits.Find('-') then begin
                     repeat
                      begin
                         Clear(UnitHeaderSet_1);
                         counts:=0;
                        repeat
                        begin
                        counts:=counts+1;
                        if Column_H[counts]=studentsUnits.Unit then UnitHeaderSet_1:=true;
                        end;
                        until counts=ArrayLen(Column_H);
                        i:=i+1;
                        if UnitHeaderSet_1=false then begin
                          Column_H[i]:=studentsUnits.Unit;
                
                // Unit Name Here
                Units.Reset;
                Units.SetRange(Units."Programme Code","ACA-Course Registration".Programme);
                Units.SetRange(Units.Code,Column_H[i]);
                if Units.Find('-') then begin
                 TColumn_V[i]:=Units.Desription;
                end;
                // Lecturer Name Here
                lectUnits.Reset;
                lectUnits.SetRange(lectUnits.Programme,"ACA-Course Registration".Programme);
                lectUnits.SetRange(lectUnits.Unit,Units.Code);
                if lectUnits.Find('-') then begin
                  uColumn_V[i]:=lectUnits.Lecturer;
                  if uColumn_V[i]<>'' then begin
                    if employee.Get(uColumn_V[i]) then begin
                    uColumn_V[i]:='';
                      if employee."First Name"<>'' then uColumn_V[i]:=employee."First Name";
                      if uColumn_V[i]<>'' then begin
                        if employee."Middle Name"<>'' then uColumn_V[i]:=uColumn_V[i]+' '+employee."Middle Name";
                        end
                      else begin if employee."Middle Name"<>'' then  uColumn_V[i]:=employee."Middle Name"; end;
                
                      if uColumn_V[i]<>'' then  begin
                        if employee."Last Name"<>'' then uColumn_V[i]:=uColumn_V[i]+' '+employee."Last Name";
                        end
                      else begin if employee."Last Name"<>'' then  uColumn_V[i]:=employee."Last Name";   end;
                
                    end;
                  end;
                end;
                          // Calculate the UnitMean and MeanGrade Here
                        //  Tcolumn_V[i]:=ROUND(Tcolumn_V[i],0.01,'=');
                        //  ucolumn_V[i]:=GetGrade(totalMarks,"Course Registration".Programme);
                        end;
                      end;
                     until studentsUnits.Next = 0;
                   end;
                  end;
                 until CReg.Next=0;
                end;
                end; // Not headerDone

            end;

            trigger OnPreDataItem()
            begin

                SCount:=0;

                //IF acadyear='' THEN ERROR('Specify the Academic Year on the Options Tab.');
                if Sems ='' then Error('Specify the Semester on the Options Tab.');
                "ACA-Course Registration".SetRange("ACA-Course Registration".Semester,Sems);
                //"ACA-Course Registration".SETRANGE("ACA-Course Registration"."Academic Year",acadyear);

                FDesc:='';
                Dept:='';
                SDesc:='';
                Comb:='';
                Clear(headerDone);
                Clear(headerDone_1);
                if GetFilter("ACA-Course Registration"."Programme Filter")='' then Error('Please specify a programme in the filters.');
                "ACA-Course Registration".SetFilter("ACA-Course Registration".Programme,'=%1',GetFilter("ACA-Course Registration"."Programme Filter"));
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(acadYears;acadyear)
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Year';
                    TableRelation = "ACA-Academic Year".Code;
                }
                field(semsz;Sems)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester';
                    TableRelation = "ACA-Semesters".Code;
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


        headerPrinted:=false;

        semesterDesc.Reset;
        //semesterDesc.SETRANGE(semesterDesc."Academic Year",acadyear);
        semesterDesc.SetRange(semesterDesc.Semester,Sems);
        if semesterDesc.Find('-') then begin
        end;
    end;

    var
        headerDone_1: Boolean;
        UnitHeaderSet_1: Boolean;
        employee: Record UnknownRecord61188;
        lectUnits: Record UnknownRecord61541;
        Column_H: array [300] of Text[100];
        Column_V: array [300] of Text[30];
        TColumn_V: array [300] of Text;
        uColumn_V: array [300] of Text[30];
        sColumn_V: array [300] of Text[30];
        totalMarks: Decimal;
        totStudents: Integer;
        stdUnits: Record UnknownRecord61549;
        counts: Integer;
        headerDone: Boolean;
        UnitHeaderSet: Boolean;
        sName: Text[200];
        cummAverage: Decimal;
        SemAverage: Decimal;
        semGrade: Code[2];
        semGPA2: Decimal;
        creg2: Record UnknownRecord61532;
        PastSemPoints: Decimal;
        PastSemHours: Decimal;
        CummGPA2: Decimal;
        intK: Integer;
        studentsUnits: Record UnknownRecord61549;
        scores: array [50] of Code[20];
        headerPrinted: Boolean;
        COUTZS: Integer;
        acadyear: Code[20];
        Sems: Code[20];
        cummGPA: Decimal;
        SemGPA: Decimal;
        Cust: Record Customer;
        Charges: Record UnknownRecord61515;
        ColumnH: array [300] of Text[100];
        ColumnV: array [300] of Text[30];
        i: Integer;
        TColumnV: array [300] of Decimal;
        SCount: Integer;
        UnitsR: Record UnknownRecord61517;
        uColumnV: array [300] of Text[30];
        sColumnV: array [300] of Text[30];
        Prog: Record UnknownRecord61511;
        Stages: Record UnknownRecord61516;
        RFound: Boolean;
        UDesc: Text[200];
        Units: Record UnknownRecord61517;
        Result: Decimal;
        Grade: Text[150];
        Remarks: Text[150];
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        TotalScore: Decimal;
        LastGrade: Code[20];
        LastScore: Decimal;
        ExitDo: Boolean;
        Desc: Text[200];
        OScore: Decimal;
        OUnits: Integer;
        MeanScore: Decimal;
        MeanGrade: Code[20];
        LastRemark: Text[200];
        CCat: Text[30];
        TScore: Decimal;
        RUnits: Decimal;
        SkipCount: Integer;
        MissingM: Boolean;
        DValue: Record "Dimension Value";
        FacultyR: Record UnknownRecord61649;
        FDesc: Text[200];
        Dept: Text[200];
        PName: Text[200];
        SDesc: Text[200];
        Comb: Text[200];
        ProgOptions: Record UnknownRecord61554;
        DMarks: Boolean;
        DSummary: Boolean;
        USkip: Boolean;
        CReg: Record UnknownRecord61532;
        UTaken: Integer;
        UPassed: Integer;
        UFailed: Integer;
        MCourse: Boolean;
        ExportToExcel: Boolean;
        constLine: Text[250];
        semesterDesc: Record UnknownRecord61654;
        Text000: label 'PRESBYTERIAN University OF EAST AFRICA';
        Text001: label 'CONSOLIDATED MARKSHEET';
        Text002: label 'CONSOLIDATED MARKSHEET';
        Text003: label 'FACULTY:';
        Text004: label 'DEPARTMENT:';
        Text005: label 'PROGRAMME OF STUDY:';
        Text006: label 'YEAR OF STUDY:';
        Text007: label 'SEQ.';
        Text008: label 'REGISTRATION NO.';
        Text009: label 'STUDENT NAME';
        Text010: label 'UNITS==>';
        Text011: label 'ACADEMIC YEAR:';
        Text012: label 'SEMESTER:';
        Text024: label '--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
        text100: label 'Guide on remarks:';
        text101: label 'P - Proceed to next year / Graduate;           Q - Take resit exam in papers failed;           R - Repeat the year';
        text102: label 'S - Special Exam;           T - Retake failed courses;           U - Missing Marks;           ? - Less courses;           Z - Discontinued';
        text103: label 'Course Categories: --- missing marks;           = Compulsory;           - Elective;           + Retake;           # Audit';


    procedure GetGrade(EXAMMark: Decimal;UnitG: Code[20]) xGrade: Text
    var
        UnitsRR: Record UnknownRecord61517;
        ProgrammeRec: Record UnknownRecord61511;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[20];
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        Grd: Code[80];
        Grade: Code[20];
        Marks: Decimal;
    begin
         Clear(Marks);
        Marks:=EXAMMark;
        GradeCategory:='';
        //UnitsRR.RESET;
        //UnitsRR.SETRANGE(UnitsRR."Programme Code","Student Units".Programme);
        //UnitsRR.SETRANGE(UnitsRR.Code,UnitG);
        //UnitsRR.SETRANGE(UnitsRR."Stage Code","Student Units".Stage);
        //IF UnitsRR.FIND('-') THEN BEGIN
        //IF UnitsRR."Default Exam Category"<>'' THEN BEGIN
        //GradeCategory:=UnitsRR."Default Exam Category";
        //END ELSE BEGIN
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(UnitG) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then  GradeCategory:='DEFAULT';//ERROR('Please note that you must specify Exam Category in Programme Setup');
        //END;
        //END;
        xGrade:='';
        if Marks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        repeat
        LastScore:=Gradings."Up to";
        if Marks < LastScore then begin
        if ExitDo = false then begin
        xGrade:=Gradings.Grade;
        if Gradings.Failed=false then
        LastRemark:='PASS'
        else
        LastRemark:='FAIL';
        ExitDo:=true;
        end;
        end;

        until Gradings.Next = 0;


        end;

        end else begin
        Grade:='';
        //Remarks:='Not Done';
        end;

        if ( (EXAMMark=0)) then xGrade:='Z' else
;


    procedure GetGPAPoints(Marks: Decimal;UnitG: Code[20]) xGPA: Decimal
    var
        UnitsRR: Record UnknownRecord61517;
        ProgrammeRec: Record UnknownRecord61511;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[20];
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        Grd: Code[80];
        Grade: Code[20];
    begin
        // CLEAR(Marks);
        //Marks:=EXAMMark;
        GradeCategory:='';
        //UnitsRR.RESET;
        //UnitsRR.SETRANGE(UnitsRR."Programme Code","Student Units".Programme);
        //UnitsRR.SETRANGE(UnitsRR.Code,UnitG);
        //UnitsRR.SETRANGE(UnitsRR."Stage Code","Student Units".Stage);
        //IF UnitsRR.FIND('-') THEN BEGIN
        //IF UnitsRR."Default Exam Category"<>'' THEN BEGIN
        //GradeCategory:=UnitsRR."Default Exam Category";
        //END ELSE BEGIN
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(UnitG) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then  GradeCategory:='DEFAULT';//ERROR('Please note that you must specify Exam Category in Programme Setup');
        //END;
        //END;
        xGPA:=0;
        if Marks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        repeat
        LastScore:=Gradings."Up to";
        if Marks < LastScore then begin
        if ExitDo = false then begin
        xGPA:=Gradings."GPA Points";
        if Gradings.Failed=false then
        LastRemark:='PASS'
        else
        LastRemark:='FAIL';
        ExitDo:=true;
        end;
        end;

        until Gradings.Next = 0;


        end;

        end else begin
        Grade:='';
        //Remarks:='Not Done';
        end;
    end;
}

