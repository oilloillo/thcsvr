 --しろかみ 黑焰的魔术师
function c60064.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x334),3,2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60064,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c60064.cost)
	e1:SetTarget(c60064.sptg)
	e1:SetOperation(c60064.spop)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_CALCULATING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c60064.atkup)
	c:RegisterEffect(e2)
	--def down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_DEFENCE_FINAL)
	e3:SetCondition(c60064.condtion)
	e3:SetValue(0)
	c:RegisterEffect(e3)
end
function c60064.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60064.spfilter(c,e,tp)
	return c:IsSetCard(0x191) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60064.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60064.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c60064.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60064.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60064.atkup(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if d and d:IsSetCard(0x191) and d:IsControler(tp) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(c60064.atkval)
	a:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_DEFENCE_FINAL)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e2:SetValue(c60064.defval)
	a:RegisterEffect(e2)
	elseif d and a:IsSetCard(0x191) and a:IsControler(tp) then
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e3:SetValue(c60064.atkval)
	d:RegisterEffect(e3)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_DEFENCE_FINAL)
	e4:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e4:SetValue(c60064.defval)
	d:RegisterEffect(e4)
	else return false end
end
function c60064.atkval(e,c)
	return c:GetAttack()/2
end
function c60064.defval(e,c)
	return c:GetDefence()/2
end
function c60064.condtion(e)
	return e:GetHandler():GetOverlayCount()~=0 and Duel.GetAttackTarget()~=nil and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler())
end
