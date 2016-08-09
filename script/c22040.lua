 --冴月麟
function c22040.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,10001,10002,true,true)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c22040.spcon)
	e1:SetOperation(c22040.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22040,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCondition(c22040.condition)
	e2:SetTarget(c22040.target)
	e2:SetOperation(c22040.operation)
	c:RegisterEffect(e2)
	--gensoukyo
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22040,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCondition(c22040.condition)
	e3:SetTarget(c22040.thtg)
	e3:SetOperation(c22040.thop)
	c:RegisterEffect(e3)
	--spsummon condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(c22040.splimit)
	c:RegisterEffect(e4)
end
function c22040.spfilter(c,code)
	return c:IsFaceup() and c:GetOriginalCode()==code and c:IsAbleToRemoveAsCost() 
end
function c22040.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.IsExistingMatchingCard(c22040.spfilter,tp,LOCATION_ONFIELD,0,1,nil,10001)
		and Duel.IsExistingMatchingCard(c22040.spfilter,tp,LOCATION_ONFIELD,0,1,nil,10002)
end
function c22040.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c22040.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,10001)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c22040.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,10002)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c22040.cfilter(c)
	return not c:IsSetCard(0x208) and c:IsType(TYPE_MONSTER)
end
function c22040.cccccccfilter(c)
	return not c:IsSetCard(0x208) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c22040.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c22040.cccccccfilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c22040.cfilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetCount()==0 and g2:GetCount()==0
end
function c22040.filter(c,e,sp)
	return c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c22040.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22040.filter(chkc,e,tp) end
	if chk==0 then return e:GetHandler():GetFlagEffect(22040)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22040.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22040.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(22040,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c22040.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22040.thfilter(c)
	return c:IsCode(10000) and c:IsAbleToHand()
end
function c22040.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22040.thfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(22040)==0 and Duel.IsExistingTarget(c22040.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c22040.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(22040,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c22040.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c22040.splimit(e,se,sp,st)
	--这个效果说的不一样啊>_>
	--当作神调整吧<_<
	return se:GetHandler()==e:GetHandler()
end
