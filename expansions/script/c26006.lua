 
--星莲-升格的妖兽 寅丸星
function c26006.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetCondition(c26006.spcon)
	e1:SetTarget(c26006.sptg)
	e1:SetOperation(c26006.spop)
	c:RegisterEffect(e1)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26006,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetTarget(c26006.target)
	e1:SetOperation(c26006.operation)
	c:RegisterEffect(e1)
end
function c26006.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x251)
end
function c26006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c26006.cfilter,1,nil,tp)
end
function c26006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26006.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x251) and c:IsLevelAbove(1)
end
function c26006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26006.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26006.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26006.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(26006,2))
	else op=Duel.SelectOption(tp,aux.Stringid(26006,2),aux.Stringid(26006,3)) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
	e:SetLabel(op)
end
function c26006.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(2)
		else e1:SetValue(-1) end
		tc:RegisterEffect(e1)
	end
	if e:GetLabel()==0 then
		Duel.Damage(tp,1000,REASON_EFFECT)
		else
		Duel.Damage(tp,500,REASON_EFFECT)
	end
end
