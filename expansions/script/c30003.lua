 
--黑魅灵
function c30003.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c30003.syncon)
	e1:SetOperation(c30003.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(c30003.valcon)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(30003,0))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCondition(c30003.damcon)
	e4:SetTarget(c30003.damtg)
	e4:SetOperation(c30003.damop)
	c:RegisterEffect(e4)
	--cannot synchro
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--cannot xyz
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6)
end
function c30003.matfilter1(c,syncard)
	return c:IsSetCard(0x6208) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c30003.matfilter2(c,syncard)	
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER)
end
function c30003.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	if c:GetFlagEffect(30000)==0 then	
	return g1:IsExists(c30003.synfilter3,1,nil,lv+tlv)
	else
	return g1:IsExists(c30003.synfilter3,1,nil,lv-tlv)
	end	
end
function c30003.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c30003.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g1=Duel.GetMatchingGroup(c30003.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c30003.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	return g2:IsExists(c30003.synfilter1,1,nil,lv,g1,g2)
end
function c30003.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c30003.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c30003.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c30003.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if mt1:GetFlagEffect(30000)==0 then	
		local t1=g1:FilterSelect(tp,c30003.synfilter3,1,1,nil,lv+lv1)
		g:Merge(t1)
		else 
		local t1=g1:FilterSelect(tp,c30003.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)
		end			
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO+REASON_RULE)
end
function c30003.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c30003.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttacker()
	if d==c then d=Duel.GetAttackTarget() end
	return c:IsRelateToBattle() and d:IsLocation(LOCATION_GRAVE) and d:IsReason(REASON_BATTLE) and d:IsType(TYPE_MONSTER)
end
function c30003.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1700)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1700)
end
function c30003.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
