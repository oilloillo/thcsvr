--Rabbit House 保登心爱
function c421401.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(421401,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c421401.target)
	e1:SetOperation(c421401.operation)
	c:RegisterEffect(e1)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(401106,1))
	e4:SetCategory(CATEGORY_LVCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c421401.lvtg)
	e4:SetOperation(c421401.lvop)
	c:RegisterEffect(e4)
end
function c421401.filter(c,e,tp)
	return c:IsSetCard(0x404) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c421401.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c421401.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c421401.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>4 then ft=4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c421401.filter,tp,LOCATION_HAND,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c421401.filter2(c)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsSetCard(0x404) and lv>0 and lv~=1
end
function c421401.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c421401.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c421401.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c421401.filter2,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
