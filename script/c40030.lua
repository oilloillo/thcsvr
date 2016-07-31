 
--精灵剑舞契约
--require "expansions/nef/elf"
function c40030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c40030.condition)
	e1:SetOperation(c40030.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40030,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(c40030.con)
	e2:SetTarget(c40030.sptg)
	e2:SetOperation(c40030.spop)
	e1:SetLabelObject(e2)
	c:RegisterEffect(e2)
end
function c40030.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local rc=Duel.AnnounceAttribute(tp,1,0xffffff)
	Elf.SetElfAttr(tp,rc)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,40030,0,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c40030.con1)
	e1:SetOperation(c40030.operation)
	e1:SetLabel(tp)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c40030.con2)
	e2:SetLabel(tp)
	Duel.RegisterEffect(e2,tp)
end
function c40030.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,40030)==0
end
function c40030.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,40030)~=0
end
function c40030.con1(e,tp,eg,ep,ev,re,r,rp)
	local attr = Elf.GetElfAttr(e:GetLabel())
	if attr==0 then return false end
    return eg:GetFirst():IsSetCard(0x430) and eg:GetFirst():IsAttribute(attr)-- and not eg:GetFirst():IsCode(40001)
end
function c40030.con2(e,tp,eg,ep,ev,re,r,rp)
    local attr = Elf.GetElfAttr(e:GetLabel())
	if attr==0 then return false end
	return eg:GetFirst():IsSetCard(0x430) and eg:GetFirst():IsAttribute(attr) and eg:GetFirst():GetSummonType()==SUMMON_TYPE_XYZ
end
function c40030.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c40030.drop)
	Duel.RegisterEffect(e1,tp)
end
function c40030.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,40030)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c40030.cfilter(c,attr)
	return c:IsFaceup() and c:IsAttribute(attr) and c:IsSetCard(0x430)
end
function c40030.filter(c,e,tp,attr)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x413) and c:IsAttribute(attr)
end
function c40030.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local attr = Elf.GetElfAttr(tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40030.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not e:GetHandler():IsPublic()
		--and Duel.IsExistingMatchingCard(c40030.cfilter,tp,LOCATION_MZONE,0,1,nil,attr)
		and Duel.IsExistingTarget(c40030.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,attr) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c40030.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,attr)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c40030.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
