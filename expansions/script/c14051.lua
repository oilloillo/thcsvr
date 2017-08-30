--梦幻馆的调停者✿艾丽
function c14051.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--instant
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14051,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c14051.condition)
	e1:SetTarget(c14051.target)
	e1:SetOperation(c14051.activate)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c14051.spcon)
	c:RegisterEffect(e1)
	--double tribute
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e5:SetValue(c14051.tricon)
	c:RegisterEffect(e5)
end
function c14051.condition(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return (tn==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)) or (tn~=tp and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c14051.filter(c)
	return (c:IsSetCard(0x3208) or c:IsSetCard(0x138)) and (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1))
end
function c14051.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14051.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c14051.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c14051.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
function c14051.cfilter(c)
	return c:IsCode(14035) and c:IsFaceup()
end
function c14051.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.IsExistingMatchingCard(c14051.cfilter,c:GetControler(),LOCATION_SZONE,LOCATION_SZONE,1,nil)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c14051.tricon(e,c)
	return c:IsSetCard(0x3208)
end
