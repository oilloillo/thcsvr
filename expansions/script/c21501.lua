--狂月与因幡的连结✿铃仙
function c21501.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c21501.matfilter,2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21501,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c21501.atktg)
	e1:SetOperation(c21501.atkop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21501,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c21501.target)
	e2:SetOperation(c21501.operation)
	c:RegisterEffect(e2)
end
function c21501.matfilter(c)
	return c:IsLevelBelow(6)
end
function c21501.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()+c:GetDefense()>0
end
function c21501.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21501.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c21501.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21501.atkfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetValue(tc:GetDefense()/2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c21501.filter(c,e,zone)
	return c:IsLevelBelow(4) and c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR) and c:IsSummonable(true,e,0,zone)
end
function c21501.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and zone~=0 and Duel.IsExistingMatchingCard(c21501.filter,tp,LOCATION_HAND,0,1,nil,e,0,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c21501.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local zone=e:GetHandler():GetLinkedZone()
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c21501.filter,tp,LOCATION_HAND,0,1,1,nil,e,0,zone)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,0,zone)
	end
end

